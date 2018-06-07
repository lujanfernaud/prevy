require 'test_helper'

class GroupMembershipNotificationTest < ActiveSupport::TestCase
  include UserSupport
  include TopicsTestCaseSupport

  def setup
    @notification =
      group_membership_notifications(:membership_notifications_one)
  end

  test "#link" do
    text   = "Go to group"
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
             group: @notification.group
           )
    end
end
