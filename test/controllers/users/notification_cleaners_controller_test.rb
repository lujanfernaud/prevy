# frozen_string_literal: true

require 'test_helper'

class Users::NotificationCleanersControllerTest < ActionDispatch::IntegrationTest
  test "should create notifications_cleaner" do
    user = users(:onitsuka)

    sign_in(user)

    assert_equal 3, user.notifications.count

    assert_difference('user.notifications.count', -3) do
      post user_notification_cleaners_url(user)
    end

    assert_redirected_to user_notifications_url(user)
  end
end
