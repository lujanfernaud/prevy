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
    group = notification.group

    NotificationRedirecter.expects(:path).with(notification, group: group)

    notification.redirecter_path(group: group)
  end
end
