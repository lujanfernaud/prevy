# Seeds groups.
class GroupSeeder
  class << self
    GROUP_SEEDS = YAML.load_file("db/seeds/group_seeds.yml")

    def create_unhidden_groups
      GROUP_SEEDS.shuffle.each_with_index do |group_seed, index|
        puts "Creating unhidden group #{index + 1} of #{GROUP_SEEDS.count}"

        group = create_unhidden_group_for group_seed
        add_random_members_to group
      end
    end

    def create_unhidden_group_for(group_seed)
      user = SampleUser.select_random(1).first

      user.owned_groups.create!(
        name:        group_seed["name"],
        description: group_seed["description"],
        location:    group_seed["location"],
        image:       File.open(group_seed["image"])
      )
    end

    def add_random_members_to(group)
      users_number = rand(6..56)

      SampleUser.select_random(users_number).each do |user|
        group.members << user
        user.add_role :member, group
      end
    end

  end
end
