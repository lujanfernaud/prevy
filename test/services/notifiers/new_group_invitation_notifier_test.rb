# frozen_string_literal: true

require 'test_helper'

class NewGroupInvitationNotifierTest < ActiveSupport::TestCase
  include MailerSupport

  def setup
    stub_sample_content_for_new_users
  end

  test "sends email notification to new user" do
    invitation = create :group_invitation

    ActionMailer::Base.deliveries.clear

    NewGroupInvitationNotifier.call(invitation)

    email_delivery = select_email_delivery_for invitation.email

    assert email_delivery
  end

  test "sends email notification to existing user" do
    user = create :user
    invitation = create :group_invitation, email: user.email

    ActionMailer::Base.deliveries.clear

    NewGroupInvitationNotifier.call(invitation)

    email_delivery = select_email_delivery_for invitation.email

    assert email_delivery
  end

  test "doesn't send email notification to existing user who opted out" do
    user = create :user, :no_emails
    invitation = create :group_invitation, email: user.email

    ActionMailer::Base.deliveries.clear

    NewGroupInvitationNotifier.call(invitation)

    email_delivery = select_email_delivery_for invitation.email

    assert_not email_delivery
  end

  test "sends internal notification to existing user" do
    user = create :user
    invitation = create :group_invitation, email: user.email

    GroupInvitationNotification.expects(:create!)

    NewGroupInvitationNotifier.call(invitation)
  end
end
