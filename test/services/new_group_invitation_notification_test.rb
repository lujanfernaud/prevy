# frozen_string_literal: true

require 'test_helper'

class NewGroupInvitationNotificationTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "sends email notification to new user" do
    invitation = create :group_invitation

    GroupInvitationEmailJob.expects(:perform_async).with(invitation)

    NewGroupInvitationNotification.call(invitation)
  end

  test "sends email notification to existing user" do
    user = create :user
    invitation = create :group_invitation, email: user.email

    GroupInvitationEmailJob.expects(:perform_async).with(invitation)

    NewGroupInvitationNotification.call(invitation)
  end

  test "doesn't send email notification to existing user who opted out" do
    user = create :user, :no_emails
    invitation = create :group_invitation, email: user.email

    GroupInvitationEmailJob.expects(:perform_async).with(invitation).never

    NewGroupInvitationNotification.call(invitation)
  end

  test "sends internal notification to existing user" do
    user = create :user
    invitation = create :group_invitation, email: user.email

    GroupInvitationNotification.expects(:create!)

    NewGroupInvitationNotification.call(invitation)
  end
end
