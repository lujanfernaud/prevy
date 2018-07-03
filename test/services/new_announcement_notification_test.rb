# frozen_string_literal: true

require 'test_helper'

class NewAnnouncementNotificationTest < ActiveSupport::TestCase
  def setup
    @group = groups(:one)
    @announcement_topic = announcement_topics(:announcement_topic_one)
  end

  test "creates notification and email notification" do
    NewAnnouncementNotification.call(@announcement_topic)

    assert_in_app_notification_for_group_members
    assert_email_notification_for_group_members
  end

  test "doesn't send email notification if user opted out" do
    unnotifiable = users(:unnotifiable)
    @group.members << unnotifiable

    NewAnnouncementNotification.call(@announcement_topic)

    assert_in_app_notification_for unnotifiable

    email_delivery = select_email_delivery_for unnotifiable

    refute email_delivery
  end

  private

    attr_reader :group, :announcement_topic

    def assert_in_app_notification_for_group_members
      group.members.each { |member| assert_in_app_notification_for member }
    end

    def assert_in_app_notification_for(member)
      notification = member.announcement_notifications.last

      assert_equal announcement_topic,       notification.topic
      assert_equal announcement_topic.group, notification.group
    end

    def assert_email_notification_for_group_members
      group.members.each do |member|
        email_delivery = select_email_delivery_for member

        assert_equal email_delivery.subject, email_subject
      end
    end

    def select_email_delivery_for(member)
      ActionMailer::Base.deliveries.select do |delivery|
        delivery.to == [member.email]
      end.first
    end

    def email_subject
      "New announcement in #{group.name}: #{announcement_topic.title}"
    end
end
