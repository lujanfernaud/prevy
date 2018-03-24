require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:phil)
    @notification = notifications(:phil_notification)
  end

  test "should get index" do
    log_in_as @user

    get user_notifications_url(@user)
    assert_response :success
  end

  test "should destroy notification" do
    log_in_as @user

    assert_difference('Notification.count', -1) do
      delete user_notification_url(@user, @notification)
    end

    assert_redirected_to user_notifications_url(@user)
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end
end
