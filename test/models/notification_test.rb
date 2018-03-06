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
end
