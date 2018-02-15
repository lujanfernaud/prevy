# Users.
27.times do |n|
  puts "Creating user #{n + 1} of 27"

  User.create!(name: Faker::Internet.user_name.capitalize + "xyz",
               email: Faker::Internet.email,
               password: "password",
               password_confirmation: "password",
               location: Faker::Address.city,
               bio: Faker::BackToTheFuture.quote)

end

def titles
  [Faker::RockBand.name, Faker::BossaNova.artist, Faker::Book.title]
end

LATLON = [
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

def address
  latlon = LATLON.sample

  { place_name: Faker::Lorem.word.capitalize,
    street1:    Faker::Address.street_address,
    street2:    Faker::Address.community,
    city:       Faker::Address.city,
    state:      Faker::Address.state,
    post_code:  Faker::Address.postcode,
    country:    Faker::Address.country,
    latitude:   latlon[:latitude],
    longitude:  latlon[:longitude] }
end

# Previous events.
27.times do |n|
  puts "Creating previous event #{n + 1} of 27"

  start_date = Faker::Date.between(6.months.ago, 1.month.ago)
  end_date   = 1.month.ago + rand(7).day

  event = Event.new
  event.title            = titles.sample + " ##{n}"
  event.description      = Faker::Lorem.paragraphs.join(" ")
  event.website          = "website.com"
  event.start_date       = start_date
  event.end_date         = end_date
  event.remote_image_url = "http://via.placeholder.com/730x411"
  event.organizer_id     = User.all.sample.id
  event.build_address(address)
  event.save(validate: false)
end

# Upcoming events.
54.times do |n|
  puts "Creating upcoming event #{n + 1} of 54"

  start_date = Faker::Date.between(1.day.from_now, 6.months.from_now)
  end_date   = start_date + 1.day

  event = Event.new(title:            titles.sample + " ##{n}",
                    description:      Faker::Lorem.paragraphs.join(" "),
                    website:          "website.com",
                    start_date:       start_date,
                    end_date:         end_date,
                    remote_image_url: "http://via.placeholder.com/730x411",
                    organizer_id:     User.all.sample.id )

  event.build_address(address)
  event.save!
end

def pick_attendee_for(event)
  loop do
    attendee = User.all.sample
    next if event.attendees.include?(attendee)

    event.attendees << attendee
    break
  end
end

# Add attendees to events.
Event.all.each do |event|
  puts "Picking attendees for event #{event.id} of #{Event.all.count}"

  rand(20).times { pick_attendee_for(event) }
end
