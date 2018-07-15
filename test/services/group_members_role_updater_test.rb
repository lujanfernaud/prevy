# frozen_string_literal: true

require 'test_helper'

class GroupMembersRoleUpdaterTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users

    @users = create_list :user, 9, :confirmed
    @group = create :group, all_members_can_create_events: false
    @group.members << @users
  end

  test "updates all members roles to organizer role" do
    @group.stubs(:saved_change_to_all_members_can_create_events?).returns(true)
    @group.stubs(:all_members_can_create_events).returns(true)

    GroupMembersRoleUpdater.call(@group)

    @group.members.each do |member|
      assert     member.has_role? :organizer, @group
      assert_not member.has_role? :member,    @group
    end
  end

  test "updates all members roles to member role" do
    @group.members.each { |member| @group.add_to_organizers(member) }

    @group.stubs(:saved_change_to_all_members_can_create_events?).returns(true)
    @group.stubs(:all_members_can_create_events).returns(false)

    GroupMembersRoleUpdater.call(@group)

    @group.members.each do |member|
      assert     member.has_role? :member,    @group
      assert_not member.has_role? :organizer, @group
    end
  end
end
