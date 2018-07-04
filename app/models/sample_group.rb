# frozen_string_literal: true

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
    add_sample_event
    add_sample_topics
    update_topics_count
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
      SampleUser.collection_for_sample_group.each do |user|
        @memberships << GroupMembership.new(group: @group, user: user)
      end

      @memberships.each do |membership|
        membership.run_callbacks(:save)   { false }
        membership.run_callbacks(:create) { false }
      end

      GroupMembership.import(@memberships)
    end

    def add_sample_organizers
      group.add_to_organizers(prevy_bot)

      SampleUser.select_random_users(2).each do |member|
        group.add_to_organizers(member)
      end
    end

    def prevy_bot
      SampleUser.find_by(email: "prevybot@prevy.test")
    end

    def add_sample_event
      SampleEvent.create_for_group(group)
    end

    def add_sample_topics
      SampleTopic.create_topics_for_group(@group)
    end

    def update_topics_count
      ActiveRecord::Base.connection.execute <<-SQL.squish
        UPDATE groups
           SET topics_count = (SELECT count(1)
                                 FROM topics
                                WHERE topics.group_id = groups.id)
      SQL
    end
end
