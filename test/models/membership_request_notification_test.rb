require 'test_helper'

class MembershipRequestNotificationTest < ActiveSupport::TestCase
  def setup
    @notification = membership_request_notifications(:one)
  end

  test "#link" do
    text   = "Go to request"
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
             membership_request: @notification.membership_request
           )
    end
end
