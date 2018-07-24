# frozen_string_literal: true

require 'test_helper'

class RemovedGroupRoleNotifierTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "sends internal notification and email to user" do
    user  = create :user
    group = create :group
    role  = "moderator"

    GroupRoleNotification.expects(:create).with(
      user:    user,
      group:   group,
      message: "You no longer have #{role} role in #{group.name}."
    )

    DeleteGroupRoleJob.expects(:perform_async).with(user, group, role)

    RemovedGroupRoleNotifier.call(user: user, group: group, role: role)
  end

  test "doesn't send email to user who opted out" do
    user  = create :user, :no_emails
    group = create :group
    role  = "organizer"

    GroupRoleNotification.expects(:create).with(
      user:    user,
      group:   group,
      message: "You no longer have #{role} role in #{group.name}."
    )

    DeleteGroupRoleJob.expects(:perform_async).with(user, group, role).never

    RemovedGroupRoleNotifier.call(user: user, group: group, role: role)
  end
end
