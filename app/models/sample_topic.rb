# frozen_string_literal: true

# Sample topics created for every new user's sample group.
class SampleTopic
  TOPIC_SEEDS = YAML.load_file("db/seeds/topic_seeds.yml").shuffle

  CREATION_DATE = 1.day.ago
  ONE_MINUTE = 60
  TWENTY_THREE_HOURS = 82_200

  def self.create_topics_for_group(group)
    new(group).create_sample_topics
  end

  def initialize(group)
    @group     = group
    @prevy_bot = group.members[0]
    @members   = group.members[1..-1].to_a
    @topics    = []
    @comments  = []
  end

  def create_sample_topics
    create_topics
    add_comments
    update_topics_last_commented_at
  end

  private

    attr_reader :group, :prevy_bot, :members, :topics

    # We are using 'activerecord-import' for bulk inserting the data.
    # https://github.com/zdennis/activerecord-import/wiki/Examples
    #
    # Callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def create_topics
      build_topics_from_topic_seeds

      Topic.import(@topics)
    end

    def build_topics_from_topic_seeds
      TOPIC_SEEDS.each { |seed| @topics << new_topic_from(seed) }
    end

    def new_topic_from(seed)
      user = select_user_for(seed)

      new_topic(
        user:  user,
        title: seed["title"],
        body:  seed["body"],
        type:  seed["type"]
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

    def new_topic(params = {})
      group.topics.new(
        user:       params[:user],
        title:      params[:title],
        body:       params[:body],
        type:       params[:type],
        edited_by:  params[:user],
        edited_at:  CREATION_DATE,
        created_at: CREATION_DATE,
        last_commented_at: CREATION_DATE
      )
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
        comments = rand(6..14)
        users = members.shuffle[0..comments]

        users.each { |user| @comments << new_comment_for(topic, user) }
      end
    end

    def new_comment_for(topic, user)
      date = CREATION_DATE + rand(ONE_MINUTE..TWENTY_THREE_HOURS)

      topic.comments.new(
        user:       user,
        body:       Faker::BackToTheFuture.quote,
        edited_by:  user,
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
end
