require 'test_helper'

class NotificationsTest < ActionDispatch::IntegrationTest
  def setup
    @phil         = users(:phil)
    @onitsuka     = users(:onitsuka)
    @stranger     = users(:stranger)
    @nike_group   = groups(:one)
    @notification = membership_request_notifications(:one)
  end

  test "group owner with requests visits notifications" do
    log_in_as @phil

    click_on "Notifications"

    assert_membership_request_notification do
      click_on "Go to request"
    end

    assert_membership_request_url

    click_on "Notifications"

    mark_notification_as_read

    refute_membership_request_notification
  end

  test "user without notifications visits notifications" do
    log_in_as @stranger

    click_on "Notifications"

    assert page.has_content? "There are no notifications."
  end

  private

    def assert_membership_request_notification(&block)
      within "#notification-#{@notification.id}" do
        assert page.has_content? @onitsuka.name
        assert page.has_content? @nike_group.name
        assert page.has_content? notification_message(@onitsuka, @nike_group)
        assert page.has_link?    "Go to request"
        assert page.has_link?    "Mark as read"

        yield if block_given?
      end
    end

    def notification_message(user, group)
      "New membership request from #{user.name} in #{group.name}."
    end

    def assert_membership_request_url
      assert page.current_url ==
        user_membership_request_url(@phil, @notification.membership_request)
    end

    def mark_notification_as_read
      within "#notification-#{@notification.id}" do
        click_on "Mark as read"
      end
    end

    def refute_membership_request_notification
      refute page.has_content? @onitsuka.name
      refute page.has_content? @nike_group.name
      refute page.has_content? notification_message(@onitsuka, @nike_group)
    end
end
