# frozen_string_literal: true

# A sample event created for every new user.
class SampleEvent
  COMMENT_SEEDS = YAML.load_file("db/seeds/event_comment_seeds.yml").shuffle

  CREATION_DATE = 1.day.ago
  ONE_MINUTE    = 60
  TWENTY_THREE_HOURS = 82_200

  def self.create_for_group(group)
    new(group).create_sample_event
  end

  def initialize(group)
    @group       = group
    @event       = nil
    @attendances = []
    @comments    = []
  end

  def create_sample_event
    create_event
    add_sample_attendees
    update_attendees_count
    add_sample_comments
    update_event_topic_dates
  end

  private

    attr_reader :group, :event

    def create_event
      prevy_bot = SampleUser.find_by(email: "prevybot@prevy.test")

      @event = group.events.build(
        organizer_id: prevy_bot.id,
        title:        event_title,
        description:  event_description,
        website:      event_website,
        start_date:   event_start_date,
        end_date:     event_end_date,
        sample_event: true
      )

      @event.build_address(event_address)
      @event.send(:set_slug)

      # We don't validate because we are not setting the image,
      # so it's going to use the default one set by EventImageUploader.
      @event.save(validate: false)
    end

    def event_title
      I18n.t("sample_event.title")
    end

    def event_description
      I18n.t("sample_event.description")
    end

    def event_website
      I18n.t("sample_event.website")
    end

    def event_start_date
      Time.zone.now + 1.month
    end

    def event_end_date
      Time.zone.now + (1.month + 3.hours)
    end

    def event_address
      {
        place_name: "Playa del Duque",
        street1:    "Costa Adeje",
        city:       "Adeje",
        post_code:  "38660",
        country:    "Spain",
        latitude:   28.0919,
        longitude:  -16.7414
      }
    end

    def add_sample_attendees
      build_attendances
      run_attendances_before_create_callbacks

      Attendance.import(@attendances)
    end

    def build_attendances
      random_members.each do |member|
        @attendances << Attendance.new(attendee: member, attended_event: event)
      end
    end

    def random_members
      group.members_with_role.shuffle[0..29]
    end

    def run_attendances_before_create_callbacks
      @attendances.each do |attendance|
        attendance.run_callbacks(:create) { false }
      end
    end

    # Some callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def add_sample_comments
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
      attendee = event.attendees.sample
      date = CREATION_DATE + rand(ONE_MINUTE..TWENTY_THREE_HOURS)

      event_topic.comments.new(
        user:       attendee,
        body:       seed["body"],
        edited_by:  attendee,
        created_at: date
      )
    end

    def event_topic
      event.topic
    end

    def run_comments_before_create_callbacks
      @comments.each do |comment|
        comment.run_callbacks(:create) { false }
        comment.user.touch
      end
    end

    # Since callbacks are not being called when importing the data,
    # we need to set the last_commented_at date manually.
    def update_event_topic_dates
      topic = event_topic

      topic.update_attribute(:created_at, CREATION_DATE)
      topic.update_attribute(:last_commented_at, last_comment_date(topic))
    end

    def last_comment_date(topic)
      topic.comments.last&.created_at
    end

    def update_attendees_count
      ActiveRecord::Base.connection.execute <<-SQL.squish
        UPDATE events
           SET attendees_count = (
             SELECT count(1)
               FROM attendances
              WHERE attendances.attended_event_id = events.id
           )
      SQL
    end
end
