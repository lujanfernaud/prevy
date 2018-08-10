# frozen_string_literal: true

# Creates sample comments for every new user's sample group's topics.
class SampleCommentsCreator
  COMMENT_SEEDS = YAML.load_file("db/seeds/terry_pratchett_quotes.yml")

  def self.call(group)
    new(group).call
  end

  def initialize(group)
    @group      = group
    @topics     = group.topics - group.event_topics
    @comments   = []
    @commenters = []
  end

  def call
    create_comments
    update_topics_last_commented_at
    update_topics_comments_count
  end

  private

    attr_reader :group, :topics

    # Some callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def create_comments
      build_comments
      run_comments_before_create_callbacks

      TopicComment.import(@comments)
    end

    def build_comments
      topics.each do |topic|
        select_commenters_for topic
        build_comments_for topic
      end
    end

    def select_commenters_for(topic)
      topic_creator = topic.user

      @commenters = members.shuffle[0..comments_count] - [topic_creator]
    end

    def members
      @_members ||= (group.members - [prevy_bot]).to_a
    end

    def prevy_bot
      @_prevy_bot ||= SampleUser.prevy_bot
    end

    def comments_count
      rand(MIN_COMMENTS..MAX_COMMENTS) - 1
    end

    def build_comments_for(topic)
      comment_seeds = COMMENT_SEEDS.shuffle

      @commenters.each do |commenter|
        comment = comment_seeds.pop

        @comments << new_comment_for(topic, commenter, comment)
      end
    end

    def new_comment_for(topic, commenter, comment)
      created_at_date = CREATION_DATE + rand(ONE_MINUTE..TWENTY_THREE_HOURS)

      topic.comments.new(
        user:       commenter,
        body:       comment,
        edited_by:  commenter,
        edited_at:  created_at_date,
        created_at: created_at_date
      )
    end

    def run_comments_before_create_callbacks
      @comments.each do |comment|
        comment.run_callbacks(:create) { false }
      end
    end

    # Since 'after_create' callbacks are not being called when importing
    # the data, we need to set the last_commented_at date manually.
    def update_topics_last_commented_at
      topics.each do |topic|
        topic.update_attribute(:last_commented_at, last_comment_date(topic))
      end
    end

    def last_comment_date(topic)
      topic.comments.last.created_at
    end

    def update_topics_comments_count
      ActiveRecord::Base.connection.execute <<~SQL
        UPDATE topics
           SET comments_count = (SELECT count(1)
                                   FROM topic_comments
                                  WHERE topic_comments.topic_id = topics.id
                                    AND topics.group_id = '#{group.id}')
      SQL
    end
end
