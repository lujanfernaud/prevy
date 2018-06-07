require 'test_helper'

class AnnouncementTopicNotificationTest < ActiveSupport::TestCase
  include UserSupport
  include TopicsTestCaseSupport

  def setup
    @notification =
      announcement_topic_notifications(:announcement_topic_notification_one)
  end

  test "#link" do
    text   = "Go to announcement"
    path   = path_with_params
    result = @notification.link

    assert_equal({ text: text, path: path }, result)
  end

  private

    def path_with_params
      Rails.application.routes.url_helpers
           .user_notification_redirecter_path(
             @notification.user,
             notification: @notification,
             group: @notification.group,
             topic: @notification.topic
           )
    end
end
