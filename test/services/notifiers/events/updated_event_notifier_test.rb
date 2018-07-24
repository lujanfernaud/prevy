# frozen_string_literal: true

require 'test_helper'

class UpdatedEventNotifierTest < ActiveSupport::TestCase
  include MailerSupport

  def setup
    stub_sample_content_for_new_users

    @group   = create :group
    @event   = create :event, group: @group, organizer: @group.owner
    @members = create_list :user, 3, :confirmed
    @group.members   << @members
    @event.attendees << @members
  end

  test "sends email notification" do
    @event.expects(:updated_fields).returns(updated_fields).twice

    ActionMailer::Base.deliveries.clear

    UpdatedEventNotifier.call(@event)

    assert_email_notification_for_group_members
  end

  test "doesn't send email notification if user opted out" do
    @event.expects(:updated_fields).returns(updated_fields).twice

    unnotifiable = create :user, :no_emails
    @group.members   << unnotifiable
    @event.attendees << unnotifiable

    ActionMailer::Base.deliveries.clear

    UpdatedEventNotifier.call(@event)

    email_delivery = select_email_delivery_for unnotifiable.email

    assert_not email_delivery
  end

  private

    def updated_fields
      { "title_updated" => "Updated event title" }
    end

    def assert_email_notification_for_group_members
      @event.attendees.each do |attendee|
        email_delivery = select_email_delivery_for attendee.email

        assert_equal email_delivery.subject, email_subject
      end
    end

    def email_subject
      "Update in #{@event.title}"
    end
end
