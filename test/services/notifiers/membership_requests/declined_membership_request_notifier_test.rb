# frozen_string_literal: true

require 'test_helper'

class DeclinedMembershipRequestNotifierTest < ActiveSupport::TestCase
  include MailerSupport

  def setup
    stub_sample_content_for_new_users
  end

  test "sends email notification" do
    group = create :group
    user  = create :user, :confirmed
    membership_request = create :membership_request, user: user, group: group

    MembershipRequestNotification.expects(:create).with(
      user: user,
      membership_request: membership_request,
      message: notification_message(group)
    )

    ActionMailer::Base.deliveries.clear

    DeclinedMembershipRequestNotifier.call(membership_request)

    email_delivery = select_email_delivery_for user.email

    assert email_delivery
  end

  test "doesn't send email notification if user opted out" do
    group = create :group
    user  = create :user, :confirmed, :no_emails
    membership_request = create :membership_request, user: user, group: group

    MembershipRequestNotification.expects(:create).with(
      user: user,
      membership_request: membership_request,
      message: notification_message(group)
    )

    ActionMailer::Base.deliveries.clear

    DeclinedMembershipRequestNotifier.call(membership_request)

    email_delivery = select_email_delivery_for user.email

    assert_not email_delivery
  end

  private

    def notification_message(group)
      "You membership request for #{group.name} was declined."
    end
end
