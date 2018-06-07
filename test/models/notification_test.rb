require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  def setup
    @user = users(:phil)
  end

  test "is valid" do
    notification = Notification.new(user: @user, message: "Test notification.")

    assert notification.valid?
  end

  test "is not valid without message" do
    notification = Notification.new(user: @user, message: "")

    assert_not notification.valid?
  end

  test "#redirecter_path" do
    notification = group_role_notifications(:roles_one)
    user  = notification.user
    group = notification.group

    expected_result = notification_redirecter_path(
      user,
      notification: notification,
      group: group
    )

    result = notification.redirecter_path(group: group)

    assert_equal expected_result, result
  end

  private

    def notification_redirecter_path(user, **params)
      Rails.application
           .routes
           .url_helpers
           .user_notification_redirecter_path(user, params)
    end
end
