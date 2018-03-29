#
# SETUP
#
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

IMAGE_PLACEHOLDER = "http://via.placeholder.com/730x411"
#
# ------
#

#
# Users
#
27.times do |n|
  puts "Creating user #{n + 1} of 27"

  User.create!(name: Faker::Internet.user_name.capitalize + "#{n}",
               email: Faker::Internet.email,
               password: "password",
               password_confirmation: "password",
               confirmed_at: Time.zone.now - 1.day,
               location: Faker::Address.city,
               bio: Faker::BackToTheFuture.quote)

end

def random_users(number = 5)
  users = []

  number.times do
    users << User.limit(1).offset(rand(User.all.count)).take
  end

  users
end
#
# ------
#

#
# Unhidden Groups
#
random_users(9).each_with_index do |user, index|
  puts "Creating unhidden group #{index + 1} of 9"

  user.owned_groups.create!(
    name: Faker::Lorem.words(2).join(" "),
    description: Faker::Lorem.paragraph * 2,
    image: File.new("test/fixtures/files/sample.jpeg"),
    private: [true, false].sample,
    hidden: false,
    all_members_can_create_events: false
  )
end
#
# ------
#

#
# Group Members
#
groups_number = Group.all.count

groups_number.times do |n|
  puts "Adding group members to group #{n + 1} of #{groups_number}"

  Group.all.each do |group|
    random_users(rand(1..9)).each do |user|
      group.members << user
    end

    group.save!
  end
end
#
# ------
#

#
# Previous Events
#
27.times do |n|
  puts "Creating previous event #{n + 1} of 27"

  start_date = Faker::Date.between(6.months.ago, 1.month.ago)
  end_date   = 1.month.ago + rand(7).day

  group = Group.all.sample
  event = group.events.build
  event.title            = titles.sample + " ##{n}"
  event.description      = Faker::Lorem.paragraphs.join(" ")
  event.website          = "website.com"
  event.start_date       = start_date
  event.end_date         = end_date
  event.remote_image_url = IMAGE_PLACEHOLDER
  event.organizer_id     = User.all.sample.id
  event.build_address(address)
  event.save(validate: false)
end
#
# ------
#

#
# Upcoming Events
#
27.times do |n|
  puts "Creating upcoming event #{n + 1} of 27"

  start_date = Faker::Date.between(1.day.from_now, 6.months.from_now)
  end_date   = start_date + 1.day

  group = Group.all.sample
  event = group.events.build(
    title:            titles.sample + " ##{n}",
    description:      Faker::Lorem.paragraphs.join(" "),
    website:          "website.com",
    start_date:       start_date,
    end_date:         end_date,
    remote_image_url: IMAGE_PLACEHOLDER,
    organizer_id:     User.all.sample.id
  )

  event.build_address(address)
  event.save!
end
#
# ------
#

#
# Add Attendees to Events
#
def pick_attendee_for(event)
  loop do
    attendee = User.all.sample
    next if event.attendees.include?(attendee)

    event.attendees << attendee
    break
  end
end

Event.all.each do |event|
  puts "Picking attendees for event #{event.id} of #{Event.all.count}"

  rand(20).times { pick_attendee_for(event) }
end
#
# ------
#
