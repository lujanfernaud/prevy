# frozen_string_literal: true

require 'test_helper'

class GroupInvitationNotificationTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "user has invitation notification" do
    user  = create :user
    group = create :group

    create :notification, :group_invitation, user: user, group_id: group.id

    assert_equal 1, user.notifications.size
  end

  test "group has invitation notification" do
    user  = create :user
    group = create :group

    create :notification, :group_invitation, user: user, group_id: group.id

    assert_equal 1, group.notifications.size
  end

  test "link path has invitation token" do
    user  = create :user
    group = create :group
    invitation = create :group_invitation, group: group, email: user.email
    create :notification, :group_invitation, user: user, group_id: group.id

    notification = user.notifications.last

    assert notification.link[:path].include?(invitation.token)
  end
end
