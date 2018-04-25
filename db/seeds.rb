require_relative "seeders/user_seeder"
require_relative "seeders/group_seeder"
require_relative "seeders/event_seeder"

#
# Create Sample Users
#

UserSeeder.create_sample_users(48)

#
# Create Unhidden Groups
#

random_users = SampleUser.select_random(24)

GroupSeeder.create_unhidden_groups_for random_users

#
# Create Events
#

EventSeeder.create_events
