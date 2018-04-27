# Seeds events.
class EventSeeder
  class << self

    def create_events
      create_previous_events(21)
      create_upcoming_events(9)
      add_attendees_to_events
    end

    def create_previous_events(events_number)
      events_number.times do |iteration|
        puts "Creating previous event #{iteration + 1} of #{events_number}"

        start_date = Faker::Date.between(6.months.ago, 1.month.ago)
        end_date   = start_date + 3.hours

        create_event(start_date, end_date, validate: false)
      end
    end

    def create_upcoming_events(events_number)
      events_number.times do |iteration|
        puts "Creating upcoming event #{iteration + 1} of #{events_number}"

        start_date = Faker::Date.between(1.month.from_now, 6.months.from_now)
        end_date   = start_date + 3.hours

        create_event(start_date, end_date, validate: true)
      end
    end

    def create_event(start_date, end_date, validate:)
      group = Group.all.sample

      event = group.events.build(
        title:            titles.sample,
        description:      Faker::Lorem.paragraphs.join(" "),
        website:          "website.com",
        start_date:       start_date,
        end_date:         end_date,
        image:            image_placeholder,
        organizer_id:     group.members.sample.id
      )

      event.build_address(address)
      event.save(validate: validate)
    end

    def add_attendees_to_events
      Event.all.each do |event|
        puts "Picking attendees for event #{event.id} of #{Event.all.count}"

        add_attendees_to event
      end
    end

    def add_attendees_to(event)
      group_members = event.group.members_with_role

      group_members.each { |member| event.attendees << member }
    end

    def titles
      [Faker::RockBand.name, Faker::BossaNova.artist]
    end

    def address
      latlon = latlon_collection.sample

      {
        place_name: Faker::Lorem.word.capitalize,
        street1:    Faker::Address.street_address,
        city:       Faker::Address.city,
        state:      Faker::Address.state,
        post_code:  Faker::Address.postcode,
        country:    Faker::Address.country,
        latitude:   latlon[:latitude],
        longitude:  latlon[:longitude]
      }
    end

    def latlon_collection
      [
        { latitude:  35.0163,  longitude:  135.7567 },
        { latitude:  20.8030,  longitude: -156.3382 },
        { latitude:  34.7117,  longitude:  135.1199 },
        { latitude:  42.3594,  longitude: -71.0959 },
        { latitude:  29.65750, longitude:  91.11667 },
        { latitude:  28.1214,  longitude: -16.7748 },
        { latitude:  27.8138,  longitude: -17.8943 },
        { latitude:  45.5428,  longitude: -122.6544 },
        { latitude: -27.4673,  longitude:  153.0701 },
        { latitude:  27.5889,  longitude:  89.8886 }
      ]
    end

    def image_placeholder
      File.open("app/assets/images/samples/sample_events/borna-bevanda-377277-unsplash.jpg")
    end

  end
end
