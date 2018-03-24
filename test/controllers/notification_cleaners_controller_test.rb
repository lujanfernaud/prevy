require 'test_helper'

class NotificationCleanersControllerTest < ActionDispatch::IntegrationTest
  test "should create notifications_cleaner" do
    user = users(:onitsuka)
    log_in_as user

    assert_equal 3, user.notifications.count

    assert_difference('user.notifications.count', -3) do
      post user_notification_cleaners_url(user)
    end

    assert_redirected_to user_notifications_url(user)
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end
end
