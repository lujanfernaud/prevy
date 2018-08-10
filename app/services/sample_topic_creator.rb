# frozen_string_literal: true

# Creates sample topics for every new user's sample group.
class SampleTopicCreator
  TOPIC_SEEDS   = YAML.load_file("db/seeds/topic_seeds.yml").shuffle
  NORMAL_TOPICS = TOPIC_SEEDS.size - 2

  def self.call(group)
    new(group).call
  end

  def initialize(group)
    @group   = group
    @topics  = []
    @members = group.members - [prevy_bot]
  end

  def call
    create_topics
    update_group_topics_count
    create_comments
  end

  private

    attr_reader :group, :topics, :members

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
        user:              user,
        title:             seed["title"],
        body:              seed["body"],
        type:              seed["type"],
        edited_by:         user,
        edited_at:         CREATION_DATE,
        created_at:        CREATION_DATE,
        last_commented_at: CREATION_DATE
      )
    end

    def select_user_for(seed)
      case seed["type"]
      when "AnnouncementTopic", "PinnedTopic"
        prevy_bot
      else
        members.pop
      end
    end

    def prevy_bot
      @_prevy_bot ||= SampleUser.prevy_bot
    end

    def run_topics_before_create_callbacks
      @topics.each do |topic|
        topic.run_callbacks(:create) { false }
      end
    end

    def update_group_topics_count
      Group.reset_counters(group.id, :topics)
    end

    def create_comments
      SampleCommentsCreator.call(group)
    end
end
