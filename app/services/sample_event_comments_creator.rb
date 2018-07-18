# frozen_string_literal: true

# Creates sample comments for every new user's sample event.
class SampleEventCommentsCreator
  COMMENT_SEEDS  = YAML.load_file("db/seeds/event_comment_seeds.yml").shuffle
  COMMENTS_COUNT = COMMENT_SEEDS.size

  def self.call(event)
    new(event).call
  end

  def initialize(event)
    @event       = event
    @event_topic = event.topic
    @attendees   = event.attendees.shuffle.dup
    @comments    = []
  end

  def call
    create_comments
    update_event_topic_dates
    update_topic_comments_count
  end

  private

    attr_reader :event, :event_topic, :attendees

    # Some callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def create_comments
      build_comments
      run_comments_before_create_callbacks

      TopicComment.import(@comments)
    end

    def build_comments
      COMMENT_SEEDS.each do |seed|
        @comments << new_comment_with(seed)
      end
    end

    def new_comment_with(seed)
      attendee = attendees.pop

      event_topic.comments.new(
        user:       attendee,
        body:       seed["body"],
        edited_by:  attendee,
        created_at: created_at_date
      )
    end

    def created_at_date
      CREATION_DATE + rand(ONE_MINUTE..TWENTY_THREE_HOURS)
    end

    def run_comments_before_create_callbacks
      @comments.each do |comment|
        comment.run_callbacks(:create) { false }
      end
    end

    # Since callbacks are not being called when importing the data,
    # we need to set the last_commented_at date manually.
    def update_event_topic_dates
      topic = event_topic

      topic.update_attribute(:created_at, CREATION_DATE)
      topic.update_attribute(:last_commented_at, last_comment_creation_date)
    end

    def last_comment_creation_date
      event_topic.comments.last.created_at
    end

    def update_topic_comments_count
      Topic.reset_counters(event_topic.id, :topic_comments)
    end
end
