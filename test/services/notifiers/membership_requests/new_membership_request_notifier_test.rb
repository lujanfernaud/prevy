# frozen_string_literal: true

require 'test_helper'

class NewMembershipRequestNotifierTest < ActiveSupport::TestCase
  include MailerSupport

  def setup
    stub_sample_content_for_new_users
  end

  test "sends email notification" do
    group = create :group
    user  = create :user, :confirmed
    membership_request = create :membership_request, user: user, group: group

    MembershipRequestNotification.expects(:create).with(
      user: group.owner,
      membership_request: membership_request,
      message: notification_message(user, group)
    )

    ActionMailer::Base.deliveries.clear

    NewMembershipRequestNotifier.call(membership_request)

    email_delivery = select_email_delivery_for group.owner.email

    assert email_delivery
  end

  test "doesn't send email notification if user opted out" do
    owner = create :user, :no_emails
    group = create :group, owner: owner
    user  = create :user, :confirmed
    membership_request = create :membership_request, user: user, group: group

    MembershipRequestNotification.expects(:create).with(
      user: group.owner,
      membership_request: membership_request,
      message: notification_message(user, group)
    )

    ActionMailer::Base.deliveries.clear

    NewMembershipRequestNotifier.call(membership_request)

    email_delivery = select_email_delivery_for owner.email

    assert_not email_delivery
  end

  private

    def notification_message(user, group)
      "New membership request from #{user.name} in #{group.name}."
    end
end
