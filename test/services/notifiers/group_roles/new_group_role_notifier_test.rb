# frozen_string_literal: true

require 'test_helper'

class NewGroupRoleNotifierTest < ActiveSupport::TestCase
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
      message: "You now have #{role} role in #{group.name}!"
    )

    AddGroupRoleJob.expects(:perform_async).with(user, group, role)

    NewGroupRoleNotifier.call(user: user, group: group, role: role)
  end

  test "doesn't send email to user who opted out" do
    user  = create :user, :no_emails
    group = create :group
    role  = "organizer"

    GroupRoleNotification.expects(:create).with(
      user:    user,
      group:   group,
      message: "You now have #{role} role in #{group.name}!"
    )

    AddGroupRoleJob.expects(:perform_async).with(user, group, role).never

    NewGroupRoleNotifier.call(user: user, group: group, role: role)
  end
end
