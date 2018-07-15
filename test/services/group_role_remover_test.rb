# frozen_string_literal: true

require 'test_helper'

class GroupRoleRemoverTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users

    @group = create :group
    @user  = create :user, :confirmed
  end

  test "removes organizer role and adds member role" do
    @user.add_role :organizer, @group

    GroupRoleRemover.call(@group, @user, :organizer)

    assert_not @group.organizers.include?        @user
    assert     @group.members_with_role.include? @user
  end

  test "removes moderator role and adds member role" do
    @user.add_role :moderator, @group

    GroupRoleRemover.call(@group, @user, :moderator)

    assert_not @group.moderators.include?        @user
    assert     @group.members_with_role.include? @user
  end

  test "removes organizer role having moderator role" do
    @user.add_role :organizer, @group
    @user.add_role :moderator, @group

    GroupRoleRemover.call(@group, @user, :organizer)

    assert_not @group.organizers.include?        @user
    assert_not @group.members_with_role.include? @user
    assert     @group.moderators.include?        @user
  end

  test "removes moderator role having organizer role" do
    @user.add_role :organizer, @group
    @user.add_role :moderator, @group

    GroupRoleRemover.call(@group, @user, :moderator)

    assert_not @group.moderators.include?        @user
    assert_not @group.members_with_role.include? @user
    assert     @group.organizers.include?        @user
  end
end
