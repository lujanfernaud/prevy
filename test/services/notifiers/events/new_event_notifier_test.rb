# frozen_string_literal: true

require 'test_helper'

class NewEventNotifierTest < ActiveSupport::TestCase
  include MailerSupport

  def setup
    stub_sample_content_for_new_users

    @group   = create :group
    @event   = create :event, group: @group, organizer: @group.owner
    @members = create_list :user, 6, :confirmed
    @group.members << @members
  end

  test "sends email notification" do
    ActionMailer::Base.deliveries.clear

    NewEventNotifier.call(@event)

    assert_email_notification_for_group_members
  end

  test "doesn't send email notification if user opted out" do
    unnotifiable = users(:unnotifiable)
    @group.members << unnotifiable

    ActionMailer::Base.deliveries.clear

    NewEventNotifier.call(@event)

    email_delivery = select_email_delivery_for unnotifiable.email

    refute email_delivery
  end

  private

    def assert_email_notification_for_group_members
      @group.members.each do |member|
        email_delivery = select_email_delivery_for member.email

        assert_equal email_delivery.subject, email_subject
      end
    end

    def email_subject
      "New event in #{@group.name}: #{@event.title}"
    end
end
