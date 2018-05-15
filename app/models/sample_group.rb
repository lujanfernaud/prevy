# A sample group created for every new user.
class SampleGroup

  def self.create_for_user(user)
    new(user).create_sample_group
  end

  def initialize(user)
    @user  = user
    @group = nil
    @memberships = []
  end

  def create_sample_group
    create_group
    add_sample_members
    add_sample_organizers
    build_sample_event
  end

  private

    attr_reader :user, :group

    def create_group
      @group = user.owned_groups.build(
        name:         group_name,
        description:  group_description,
        location:     group_location,
        sample_group: true
      )

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

    def add_sample_members
      create_memberships
      add_member_role_to_memberships
    end

    # We are using 'activerecord-import' for bulk inserting the data.
    # https://github.com/zdennis/activerecord-import/wiki/Examples
    def create_memberships
      SampleUser.all.each do |user|
        @memberships << GroupMembership.new(group: @group, user: user)
      end

      GroupMembership.import(@memberships)
    end

    def add_member_role_to_memberships
      # https://github.com/zdennis/activerecord-import/wiki/Callbacks
      @memberships.each do |membership|
        membership.run_callbacks(:save) { false }
      end
    end

    def add_sample_organizers
      random_members(4).each { |member| group.add_to_organizers(member) }
    end

    def random_members(number)
      members = group.members
      random_offset = rand(members.count - number)

      members.offset(random_offset).limit(number)
    end

    def build_sample_event
      SampleEvent.build_for_group(group)
    end

end
