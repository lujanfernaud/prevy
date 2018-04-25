# Seeds groups.
class GroupSeeder
  class << self

    def create_unhidden_groups_for(users)
      users.each_with_index do |user, index|
        puts "Creating unhidden group #{index + 1} of #{users.count}"

        group = create_unhidden_group_for user
        add_random_members_to group
      end
    end

    def create_unhidden_group_for(user)
      user.owned_groups.create!(
        name:        Faker::Lorem.words(2).join(" "),
        description: Faker::Lorem.paragraph * 2,
        location:    Faker::Address.city,
        image:       File.new("test/fixtures/files/sample.jpeg")
      )
    end

    def add_random_members_to(group)
      users_number = rand(6..27)

      SampleUser.select_random(users_number).each do |user|
        group.members << user
        user.add_role :member, group
      end
    end

  end
end
