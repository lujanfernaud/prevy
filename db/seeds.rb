require_relative "seeders/user_seeder"
require_relative "seeders/group_seeder"

#
# Create Admin
#

puts "Creating admin"

User.create!(
  name:         "Luján Fernaud",
  email:        "lujanfernaud@prevy.test",
  location:     "Tenerife, Canary Islands, Spain",
  bio:          "Full-stack Rails Developer. Rubyist. Tinkerer.",
  password:     "changeme",
  confirmed_at: Time.zone.now,
  admin:        true
)

#
# Create Prevy Bot
#

puts "Creating Prevy Bot"

SampleUser.create!(
  name:         "Prevy Bot",
  email:        "prevybot@prevy.test",
  location:     "The Interwebs",
  bio:          "Full-time Prevy sample content creator, and loving it!",
  password:     SecureRandom.base64(21),
  confirmed_at: Time.zone.now
)


#
# Create Sample Users
#

UserSeeder.create_sample_users(57)

#
# Create Unhidden Groups
#

GroupSeeder.create_unhidden_groups

#
# Update Admin Data Reminder
#

system "clear" or system "cls"

puts "-" * 44
puts "Seeding finished."
puts
puts "Remember to update admin email and password."
puts "-" * 44
puts
