require 'test_helper'

class NotificationCleanersControllerTest < ActionDispatch::IntegrationTest
  test "should create notifications_cleaner" do
    user = users(:onitsuka)

    assert_equal 3, user.notifications.count

    assert_difference('user.notifications.count', -3) do
      post user_notification_cleaners_url(user)
    end

    assert_redirected_to user_notifications_url(user)
  end
end
