# frozen_string_literal: true

# Seeds groups.
class GroupSeeder
  class << self
    GROUP_SEEDS = YAML.load_file("db/seeds/group_seeds.yml")

    def create_unhidden_groups
      GROUP_SEEDS.shuffle.each_with_index do |group_seed, index|
        puts "Creating unhidden group #{index + 1} of #{GROUP_SEEDS.size}"

        group = create_unhidden_group_for group_seed
        add_random_members_to group
      end
    end

    def create_unhidden_group_for(group_seed)
      user = SampleUser.select_random_users(1).first

      user.owned_groups.create!(
        name:        group_seed["name"],
        description: group_seed["description"],
        location:    group_seed["location"],
        image:       File.open(group_seed["image"])
      )
    end

    def add_random_members_to(group)
      sample_users = SampleUser.collection_for_sample_group
      max_number = rand(9..sample_users.size)
      selected_users = sample_users[0..max_number]

      selected_users.each { |user| group.members << user }
    end

  end
end
