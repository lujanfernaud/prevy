# frozen_string_literal: true

# Sample topics created for every new user's sample group.
class SampleTopic
  TOPIC_SEEDS = YAML.load_file("db/seeds/topic_seeds.yml").shuffle

  CREATION_DATE = 1.day.ago
  MIN_COMMENTS  = 7
  MAX_COMMENTS  = 15
  ONE_MINUTE    = 60
  TWENTY_THREE_HOURS = 82_200

  def self.create_topics_for_group(group)
    new(group).create_sample_topics
  end

  def initialize(group)
    @group      = group
    @topics     = []
    @comments   = []
    @commenters = []
  end

  def create_sample_topics
    create_topics
    add_comments
    update_topics_last_commented_at
    update_topics_comments_count
  end

  private

    attr_reader :group, :topics

    # We are using 'activerecord-import' for bulk inserting the data.
    # https://github.com/zdennis/activerecord-import/wiki/Examples
    #
    # Callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def create_topics
      build_topics_from_topic_seeds
      run_topics_before_create_callbacks

      Topic.import(@topics)
    end

    def build_topics_from_topic_seeds
      TOPIC_SEEDS.each do |seed|
        @topics << new_topic_from(seed)
      end
    end

    def new_topic_from(seed)
      user = select_user_for seed

      group.topics.new(
        user:       user,
        title:      seed["title"],
        body:       seed["body"],
        type:       seed["type"],
        edited_by:  user,
        edited_at:  CREATION_DATE,
        created_at: CREATION_DATE,
        last_commented_at: CREATION_DATE
      )
    end

    def select_user_for(seed)
      case seed["type"]
      when "AnnouncementTopic", "PinnedTopic"
        prevy_bot
      else
        members.sample
      end
    end

    def prevy_bot
      @_prevy_bot ||= group.members[0]
    end

    def members
      @_members ||= group.members[1..-1].to_a
    end

    def run_topics_before_create_callbacks
      @topics.each do |topic|
        topic.run_callbacks(:create) { false }
      end
    end

    # Some callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def add_comments
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

    def comments_count
      rand(MIN_COMMENTS..MAX_COMMENTS) - 1
    end

    def build_comments_for(topic)
      @commenters.each do |commenter|
        @comments << new_comment_for(topic, commenter)
      end
    end

    def new_comment_for(topic, commenter)
      date = CREATION_DATE + rand(ONE_MINUTE..TWENTY_THREE_HOURS)

      topic.comments.new(
        user:       commenter,
        body:       Faker::BackToTheFuture.quote,
        edited_by:  commenter,
        created_at: date
      )
    end

    def run_comments_before_create_callbacks
      @comments.each do |comment|
        comment.run_callbacks(:create) { false }
        comment.user.touch
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
      topic.comments.last&.created_at
    end

    def update_topics_comments_count
      ActiveRecord::Base.connection.execute <<-SQL.squish
        UPDATE topics
           SET comments_count = (SELECT count(1)
                                   FROM topic_comments
                                  WHERE topic_comments.topic_id = topics.id)
      SQL
    end
end
