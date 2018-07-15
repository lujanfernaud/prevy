# frozen_string_literal: true

require 'test_helper'

class GroupRoleAdderTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users

    @group = create :group
    @user  = create :user, :confirmed
  end

  test "adds organizer role and removes member role" do
    @user.add_role :member, @group

    GroupRoleAdder.call(@group, @user, :organizer)

    assert     @group.organizers.include?        @user
    assert_not @group.members_with_role.include? @user
  end

  test "adds moderator role and removes member role" do
    @user.add_role :member, @group

    GroupRoleAdder.call(@group, @user, :moderator)

    assert     @group.moderators.include?        @user
    assert_not @group.members_with_role.include? @user
  end

  test "adds organizer role and keeps moderator role" do
    @user.add_role :moderator, @group

    GroupRoleAdder.call(@group, @user, :organizer)

    assert @group.moderators.include? @user
    assert @group.organizers.include? @user
  end

  test "adds moderator role and keeps organizer role" do
    @user.add_role :organizer, @group

    GroupRoleAdder.call(@group, @user, :moderator)

    assert @group.moderators.include? @user
    assert @group.organizers.include? @user
  end
end
