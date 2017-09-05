# Users.
27.times do
  User.create!(name: Faker::Internet.user_name.capitalize,
               email: Faker::Internet.email,
               password: "password",
               password_confirmation: "password")
end

titles = [Faker::RockBand.name, Faker::BossaNova.artist, Faker::Book.title]

# Previous events.
27.times do |n|
  start_date = Faker::Date.between(6.months.ago, 1.month.ago)
  end_date   = 1.month.ago + rand(7).day

  event = Event.new
  event.title        = titles.sample + " ##{n}"
  event.description  = Faker::Lorem.paragraph
  event.start_date   = start_date
  event.end_date     = end_date
  event.organizer_id = User.all.sample.id
  event.save(validate: false)
end

# Upcoming events.
54.times do |n|
  start_date = Faker::Date.between(1.day.from_now, 6.months.from_now)
  end_date   = start_date + 1.day

  Event.create!(title: titles.sample + " ##{n}",
                description: Faker::Lorem.paragraph,
                start_date: start_date,
                end_date: end_date,
                organizer_id: User.all.sample.id )
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
  rand(20).times { pick_attendee_for(event) }
end
