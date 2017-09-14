# Users.
27.times do |n|
  puts "Creating user #{n + 1} of 27"

  User.create!(name: Faker::Internet.user_name.capitalize + "xyz",
               email: Faker::Internet.email,
               password: "password",
               password_confirmation: "password")

end

def titles
  [Faker::RockBand.name, Faker::BossaNova.artist, Faker::Book.title]
end

def address
  { place_name: Faker::Lorem.word.capitalize,
    street1:    Faker::Address.street_address,
    street2:    Faker::Address.community,
    city:       Faker::Address.city,
    state:      Faker::Address.state,
    post_code:  Faker::Address.postcode,
    country:    Faker::Address.country }
end

# Previous events.
27.times do |n|
  puts "Creating previous event #{n + 1} of 27"

  start_date = Faker::Date.between(6.months.ago, 1.month.ago)
  end_date   = 1.month.ago + rand(7).day

  event = Event.new
  event.title            = titles.sample + " ##{n}"
  event.description      = Faker::Lorem.paragraphs.join(" ")
  event.start_date       = start_date
  event.end_date         = end_date
  event.remote_image_url = Faker::LoremPixel.image("730x411")
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
                    start_date:       start_date,
                    end_date:         end_date,
                    remote_image_url: Faker::LoremPixel.image("730x411"),
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
