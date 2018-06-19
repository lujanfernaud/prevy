# frozen_string_literal: true

# Sample topics created for every new user's sample group.
class SampleTopic
  TOPIC_SEEDS = YAML.load_file("db/seeds/topic_seeds.yml").shuffle

  def self.create_topics_for_group(group)
    new(group).create_sample_topics
  end

  def initialize(group)
    @group    = group
    @topics   = []
    @comments = []
  end

  def create_sample_topics
    create_normal_topics
    create_announcement_topic
    create_pinned_topic
    add_comments
  end

  private

    attr_reader :group, :topics

    # We are using 'activerecord-import' for bulk inserting the data.
    # https://github.com/zdennis/activerecord-import/wiki/Examples
    #
    # Callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def create_normal_topics
      TOPIC_SEEDS.each { |seed| @topics << new_topic_with(seed) }

      Topic.import(@topics)
    end

    def new_topic_with(seed)
      user = group.members.sample

      group.topics.new(
        user:      user,
        title:     Faker::Music.album,
        body:      seed["body"],
        edited_by: user,
        last_commented_at: Time.current
      )
    end

    def create_announcement_topic
      @topics << group.announcement_topics.create!(
        user:  group.owner,
        title: "Sample announcement",
        body:  "You can create an announcement topic and all members of the group will receive a notification email."
      )
    end

    def create_pinned_topic
      @topics << group.pinned_topics.create!(
        user:  group.owner,
        title: "Sample pinned topic",
        body:  "Pinned topics can be handy for specifying group rules, introductions ('Introduce Yourself'), or to give more importance to normal topics for a while."
      )
    end

    # Callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def add_comments
      topics.each do |topic|
        rand(5..15).times { @comments << new_comment_for(topic) }
      end

      TopicComment.import(@comments)
    end

    def new_comment_for(topic)
      user = group.members.sample

      topic.comments.new(
        user:      user,
        body:      Faker::BackToTheFuture.quote,
        edited_by: user
      )
    end
end
