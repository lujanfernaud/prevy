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
        bio:      Faker::BackToTheFuture.quote
      )
    end

    def full_name
      Faker::Name.first_name + " " + Faker::Name.last_name
    end

  end
end
