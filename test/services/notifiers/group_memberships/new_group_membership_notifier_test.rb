# frozen_string_literal: true

require 'test_helper'

class NewGroupMembershipNotifierTest < ActiveSupport::TestCase
  include MailerSupport

  def setup
    stub_sample_content_for_new_users

    @group = create :group
  end

  test "sends email notification" do
    user = create :user, :confirmed
    group_membership = create :group_membership, user: user, group: @group

    ActionMailer::Base.deliveries.clear

    NewGroupMembershipNotifier.call(group_membership)

    assert_email_notification_for_group_members
  end

  test "doesn't send email notification if user opted out" do
    user = create :user, :confirmed, :no_emails
    group_membership = create :group_membership, user: user, group: @group

    ActionMailer::Base.deliveries.clear

    NewGroupMembershipNotifier.call(group_membership)

    email_delivery = select_email_delivery_for user.email

    assert_not email_delivery
  end

  private

    def assert_email_notification_for_group_members
      @group.members.each do |member|
        email_delivery = select_email_delivery_for member.email

        assert_equal email_delivery.subject, email_subject
      end
    end

    def email_subject
      "#{@group.name} membership"
    end
end
