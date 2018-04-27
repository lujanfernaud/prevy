# A sample event created for every new user.
class SampleEvent

  def self.build_for_group(group)
    new(group).build_sample_event
  end

  def initialize(group)
    @group = group
    @event = nil
  end

  def build_sample_event
    build_event
    add_sample_attendees
  end

  private

    attr_reader :group

    def build_event
      @event = group.events.build(
        organizer_id: group.owner.id,
        title:        event_title,
        description:  event_description,
        website:      event_website,
        start_date:   event_start_date,
        end_date:     event_end_date,
        image:        event_image
      )

      @event.build_address(event_address)
      @event.save!
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

    def event_image
      File.open("app/assets/images/samples/adam-whitlock-270558-unsplash.jpg")
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
      random_members = group.members_with_role.shuffle[0..29]

      random_members.each do |member|
        @event.attendees << member
      end
    end
end
