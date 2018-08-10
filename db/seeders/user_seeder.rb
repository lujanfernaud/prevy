# frozen_string_literal: true

# Seeds sample users.
class UserSeeder
  BIO_SEEDS = YAML.load_file("db/seeds/terry_pratchett_quotes.yml").shuffle

  class << self

    def create_sample_users(users_number)
      users_number.times do |iteration|
        puts "Creating user #{iteration + 1} of #{users_number}"

        create_sample_user
      end
    end

    def create_sample_user
      bio = BIO_SEEDS.pop

      SampleUser.create!(
        name:     full_name,
        email:    Faker::Internet.email,
        password: "password",
        location: Faker::Address.city,
        bio:      bio,
        settings: {
          "membership_request_emails": false,
          "group_membership_emails":   false,
          "group_role_emails":         false,
          "group_event_emails":        false,
          "group_announcement_emails": false,
          "group_invitation_emails":   false
        }
      )
    end

    def full_name
      Faker::Name.first_name + " " + Faker::Name.last_name
    end

  end
end
