# frozen_string_literal: true

# Creates a sample group for every new user.
class SampleGroupCreator
  RANDOM_ORGANIZERS = 2
  PREVY_BOT         = 1
  GROUP_OWNER       = 1
  TOTAL_ORGANIZERS  = RANDOM_ORGANIZERS + PREVY_BOT + GROUP_OWNER

  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user         = user
    @group        = nil
    @sample_users = SampleUser.collection_for_sample_group
    @memberships  = []
    @roles        = []
    @user_roles   = []
  end

  def call
    create_group
    add_sample_members
    update_members_count
    add_sample_organizers

    group
  end

  private

    attr_reader :user, :group, :sample_users

    def create_group
      @group = user.owned_groups.build(
        name:         group_name,
        description:  group_description,
        location:     group_location,
        sample_group: true
      )

      @group.send(:set_slug)

      # We don't validate because we are not setting the image,
      # so it's going to use the default one set by GroupImageUploader.
      @group.save(validate: false)
    end

    def group_name
      I18n.t("sample_group.name")
    end

    def group_description
      I18n.t("sample_group.description", user_name: user.name)
    end

    def group_location
      I18n.t("sample_group.location")
    end

    # We are using 'activerecord-import' for bulk inserting the data.
    # https://github.com/zdennis/activerecord-import/wiki/Examples
    #
    # Callbacks are not being called to increase performance.
    def add_sample_members
      build_memberships
      build_roles
      build_user_roles

      GroupMembership.import(@memberships)
      Role.import(@roles)
      UserRole.import(@user_roles)
    end

    def build_memberships
      sample_users.each do |user|
        @memberships << GroupMembership.new(group: group, user: user)
      end
    end

    def build_roles
      sample_users.each do |user|
        @roles << user.roles.new(resource: group, name: "member")
      end
    end

    def build_user_roles
      @roles.each.with_index do |role, index|
        @user_roles << UserRole.new(role: role, user: sample_users[index])
      end
    end

    def update_members_count
      Group.reset_counters(group.id, :members)
    end

    def add_sample_organizers
      group.add_to_organizers(SampleUser.prevy_bot)

      SampleUser.select_random_users(RANDOM_ORGANIZERS).each do |member|
        group.add_to_organizers(member)
      end
    end
end
