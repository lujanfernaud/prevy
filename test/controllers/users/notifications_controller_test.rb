# frozen_string_literal: true

require 'test_helper'

class Users::NotificationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:phil)
    @notification = group_role_notifications(:roles_one)
  end

  test "should get index" do
    sign_in(@user)

    get user_notifications_url(@user)
    assert_response :success
  end

  test "should get edit notification settings" do
    sign_in(@user)

    get user_notification_settings_url(@user)
    assert_response :success
  end

  test "should update notification settings" do
    sign_in(@user)

    put user_notification_settings_url(@user), params: notification_params
    assert_response :success
  end

  test "should destroy notification" do
    sign_in(@user)

    assert_difference('Notification.count', -1) do
      delete user_notification_url(@user, @notification)
    end

    assert_redirected_to user_notifications_url(@user)
  end

  private

    def notification_params
      {
        user: {
          membership_request_emails: true,
          group_membership_emails: true,
          group_role_emails: true
        }
      }
    end
end
