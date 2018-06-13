# frozen_string_literal: true

# Sample topics created for every new user's sample group.
class SampleTopic
  TOPIC_SEEDS = YAML.load_file("db/seeds/topic_seeds.yml").shuffle

  def self.create_topics_for_group(group)
    new(group).create_sample_topics
  end

  def self.create_announcement_topic_for_group(group)
    new(group).create_sample_announcement_topic
  end

  def initialize(group)
    @group    = group
    @topics   = []
    @comments = []
  end

  def create_sample_topics
    create_topics
    add_comments
  end

  def create_sample_announcement_topic
    create_announcement_topic
    add_comments
  end

  private

    attr_reader :group, :topics

    def create_topics
      TOPIC_SEEDS.each { |seed| @topics << new_topic_with(seed) }

      Topic.import(@topics)
    end

    def new_topic_with(seed)
      user = group.members.sample

      group.topics.new(
        user:      user,
        title:     Faker::Music.album,
        body:      seed["body"],
        edited_by: user
      )
    end

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

    def create_announcement_topic
      @topics << group.announcement_topics.create!(
        user:  group.owner,
        title: "Sample announcement",
        body:  "You can create an announcement topic and all members of the group will receive a notification email."
      )
    end
end
