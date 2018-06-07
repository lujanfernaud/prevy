require 'test_helper'

class NotificationRedirecterTest < ActiveSupport::TestCase
  test ".path" do
    notification = group_role_notifications(:roles_one)
    user  = notification.user
    group = notification.group

    expected_result = notification_redirecter_path(
      user,
      notification: notification,
      group: group
    )

    result = NotificationRedirecter.path(notification, group: group)

    assert_equal expected_result, result
  end

  private

    def notification_redirecter_path(user, **params)
      Rails.application.routes.url_helpers
           .user_notification_redirecter_path(user, params)
    end
end
