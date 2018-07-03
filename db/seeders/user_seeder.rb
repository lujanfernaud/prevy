# frozen_string_literal: true

# Seeds sample users.
class UserSeeder
  class << self

    def create_sample_users(users_number)
      users_number.times do |iteration|
        puts "Creating user #{iteration + 1} of #{users_number}"

        create_sample_user
      end
    end

    def create_sample_user
      SampleUser.create!(
        name:     full_name,
        email:    Faker::Internet.email,
        password: "password",
        location: Faker::Address.city,
        bio:      Faker::BackToTheFuture.quote,
        settings: {
          "membership_request_emails": false,
          "group_membership_emails": false,
          "group_role_emails": false,
          "new_event_emails": false
        }
      )
    end

    def full_name
      Faker::Name.first_name + " " + Faker::Name.last_name
    end

  end
end
