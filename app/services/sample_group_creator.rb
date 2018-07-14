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
    @user        = user
    @group       = nil
    @memberships = []
  end

  def call
    create_group
    add_sample_members
    update_members_count
    add_sample_organizers
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
    # Some callbacks are not being called.
    # https://github.com/zdennis/activerecord-import/wiki/Callbacks
    def add_sample_members
      build_memberships
      run_before_callbacks

      GroupMembership.import(@memberships)
    end

    def build_memberships
      SampleUser.collection_for_sample_group.each do |user|
        @memberships << GroupMembership.new(group: @group, user: user)
      end
    end

    def run_before_callbacks
      @memberships.each do |membership|
        membership.run_callbacks(:save)   { false }
        membership.run_callbacks(:create) { false }
      end
    end

    def update_members_count
      ActiveRecord::Base.connection.execute <<-SQL.squish
        UPDATE groups
           SET members_count = (SELECT count(1)
                                  FROM group_memberships
                                 WHERE group_memberships.group_id = groups.id
                                   AND groups.id = '#{group.id}')
      SQL
    end

    def add_sample_organizers
      group.add_to_organizers(SampleUser.prevy_bot)

      SampleUser.select_random_users(RANDOM_ORGANIZERS).each do |member|
        group.add_to_organizers(member)
      end
    end
end
