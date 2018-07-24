# frozen_string_literal: true

require 'test_helper'

class RemovedGroupRoleNotifierTest < ActiveSupport::TestCase
  include MailerSupport

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
      message: notification_message(role, group)
    )

    ActionMailer::Base.deliveries.clear

    RemovedGroupRoleNotifier.call(user: user, group: group, role: role)

    email_delivery = select_email_delivery_for user.email

    assert_equal(
      email_delivery.subject,
      notification_message(role, group).sub(".", "")
    )
  end

  test "doesn't send email to user who opted out" do
    user  = create :user, :no_emails
    group = create :group
    role  = "organizer"

    GroupRoleNotification.expects(:create).with(
      user:    user,
      group:   group,
      message: notification_message(role, group)
    )

    ActionMailer::Base.deliveries.clear

    RemovedGroupRoleNotifier.call(user: user, group: group, role: role)

    email_delivery = select_email_delivery_for user.email

    assert_not email_delivery
  end

  private

    def notification_message(role, group)
      "You no longer have #{role} role in #{group.name}."
    end
end
