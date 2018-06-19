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
    @group    = group
    @topics   = []
    @comments = []
  end

  def create_sample_topics
    create_topics
    add_comments
    update_topics_last_commented_at
  end

  private

    attr_reader :group, :topics

    # We are using 'activerecord-import' for bulk inserting the data.
    # https://github.com/zdennis/activerecord-import/wiki/Examples
    #
    # Callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def create_topics
      add_normal_topics
      add_announcement_topic
      add_pinned_topic

      Topic.import(@topics)
    end

    def add_normal_topics
      TOPIC_SEEDS.each { |seed| @topics << new_topic_with_seed(seed) }
    end

    def new_topic_with_seed(seed)
      user = group.members.sample

      new_topic(
        user:  user,
        title: Faker::Music.album,
        body:  seed["body"]
      )
    end

    def new_topic(params = {})
      group.topics.new(
        user:       params[:user],
        title:      params[:title],
        body:       params[:body],
        type:       params[:type] || "Topic",
        edited_by:  params[:user],
        edited_at:  CREATION_DATE,
        created_at: CREATION_DATE,
        last_commented_at: CREATION_DATE
      )
    end

    def add_announcement_topic
      user = group.owner

      @topics << new_topic(
        user:  user,
        title: "Sample announcement",
        body:  "You can create an announcement topic and all members of the group will receive a notification email.",
        type:  "AnnouncementTopic"
      )
    end

    def add_pinned_topic
      user = group.owner

      @topics << new_topic(
        user:  user,
        title: "Sample pinned topic",
        body:  "Pinned topics can be handy for specifying group rules, introductions ('Introduce Yourself'), or to give more importance to normal topics for a while.",
        type:  "PinnedTopic"
      )
    end

    # Callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def add_comments
      topics.each do |topic|
        rand(5..13).times { @comments << new_comment_for(topic) }
      end

      TopicComment.import(@comments)
    end

    def new_comment_for(topic)
      user = group.members.sample
      date = CREATION_DATE + rand(ONE_MINUTE..TWENTY_THREE_HOURS)

      topic = topic.comments.new(
        user:       user,
        body:       Faker::BackToTheFuture.quote,
        edited_by:  user,
        created_at: date
      )
    end

    # Since callbacks are not being called when importing the data,
    # we need to set the last_commented_at date manually.
    def update_topics_last_commented_at
      topics.each do |topic|
        topic.update_attribute(:last_commented_at, last_comment_date(topic))
      end
    end

    def last_comment_date(topic)
      topic.comments.last&.created_at
    end
end
