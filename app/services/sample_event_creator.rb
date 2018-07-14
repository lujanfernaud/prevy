# frozen_string_literal: true

# Creates a sample event for every new user's sample group.
class SampleEventCreator
  def self.call(group)
    new(group).call
  end

  def initialize(group)
    @group       = group
    @event       = nil
    @attendances = []
  end

  def call
    create_event
    add_sample_attendees
    update_attendees_count
    create_comments
  end

  private

    attr_reader :group, :event

    def create_event
      @event = group.events.build(event_attributes)
      @event.build_address(address_attributes)

      # Set FriendlyId slug.
      @event.send(:set_slug)

      # We don't validate because we are not setting the image,
      # so it's going to use the default one set by EventImageUploader.
      @event.save(validate: false)
    end

    def event_attributes
      {
        organizer_id: prevy_bot.id,
        title:        event_title,
        description:  event_description,
        website:      event_website,
        start_date:   event_start_date,
        end_date:     event_end_date,
        sample_event: true
      }
    end

    def prevy_bot
      @_prevy_bot ||= SampleUser.prevy_bot
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

    def address_attributes
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

    def update_attendees_count
      ActiveRecord::Base.connection.execute <<-SQL.squish
        UPDATE events
           SET attendees_count = (
             SELECT count(1)
               FROM attendances
              WHERE attendances.attended_event_id = events.id
                AND events.id = '#{event.id}'
           )
      SQL
    end

    def create_comments
      SampleEventCommentsCreator.call(event)
    end
end
