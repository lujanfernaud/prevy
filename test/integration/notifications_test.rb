require 'test_helper'

class NotificationsTest < ActionDispatch::IntegrationTest
  def setup
    @phil          = users(:phil)
    @carolyn       = users(:carolyn)
    @onitsuka      = users(:onitsuka)
    @stranger      = users(:stranger)
    @unnotifiable  = users(:unnotifiable)
    @nike_group    = groups(:one)
    @notification  = membership_request_notifications(:two)
    @phil.add_role :organizer, @nike_group
  end

  test "user tries to visit other user's notifications" do
    log_in_as(@carolyn)

    visit user_notifications_path(@phil)

    refute page.current_path == user_notifications_path(@phil)
  end

  test "group owner visits notifications and accepts request" do
    log_in_as(@phil)

    click_on "Notifications"

    assert_membership_request_notification(@carolyn) do
      click_on "Go to request"
    end

    assert_membership_request_url

    click_on "Notifications"

    refute_membership_request_notification(@carolyn)

    click_on @phil.name
    click_on "Membership requests"

    within membership_request_from(@carolyn) do
      click_on "Accept"
    end

    log_out_as(@phil)

    log_in_as(@carolyn)

    click_on "Notifications"

    within last_notification_for(@carolyn) do
      click_on "Go to group"
    end

    assert page.current_path == group_path(@nike_group)

    click_on "Notifications"

    assert page.has_content? "There are no notifications."
  end

  test "user without notifications visits notifications" do
    log_in_as(@stranger)

    click_on "Notifications"

    assert page.has_content? "There are no notifications."
  end

  test "user doesn't receive membership request email notifications" do
    request_membership_as_unnotifiable

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit user_membership_requests_url(@phil)

    within last_membership_request do
      click_on "Decline"
    end

    log_out_as(@phil)

    log_in_as(@unnotifiable)

    assert_regular_notifications
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "user doesn't receive group membership email notifications" do
    request_membership_as_unnotifiable

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit user_membership_requests_url(@phil)

    within last_membership_request do
      click_on "Accept"
    end

    log_out_as(@phil)

    log_in_as(@unnotifiable)

    assert_regular_notifications
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "user doesn't receive group role email notifications" do
    @unnotifiable.add_role(:member, @nike_group)

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit group_members_url(@nike_group)

    within "#user-#{@unnotifiable.id}" do
      click_on "Add to organizers"
    end

    log_out_as(@phil)

    log_in_as(@unnotifiable)

    assert_regular_notifications
    assert_equal 0, ActionMailer::Base.deliveries.size

    log_out_as(@unnotifiable)

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit group_members_url(@nike_group)

    within "#user-#{@unnotifiable.id}" do
      click_on "Delete from organizers"
    end

    log_out_as(@phil)

    log_in_as(@unnotifiable)

    assert_regular_notifications
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "user marks all notifications as read" do
    log_in_as(@onitsuka)

    visit user_notifications_url(@onitsuka)

    click_on "Mark all as read"

    assert page.current_path == user_notifications_path(@onitsuka)
    assert page.has_content? "There are no notifications"
    refute page.has_link?    "Mark all as read"
  end

  test "active tab in notification settings is 'Notifications' tab" do
    log_in_as(@onitsuka)

    visit user_notification_settings_url(@onitsuka)

    within ".nav-item-notifications" do
      assert page.has_css? ".nav-link.active"
    end
  end

  test "user modifies notification settings" do
    log_in_as(@onitsuka)

    visit user_notification_settings_url(@onitsuka)

    assert page.has_checked_field? "user_membership_request_emails"
    assert page.has_checked_field? "user_group_membership_emails"
    assert page.has_checked_field? "user_group_role_emails"

    uncheck "user_membership_request_emails"
    uncheck "user_group_membership_emails"
    uncheck "user_group_role_emails"

    click_on "Update"

    assert page.has_content? "updated"

    assert page.has_no_checked_field? "user_membership_request_emails"
    assert page.has_no_checked_field? "user_group_membership_emails"
    assert page.has_no_checked_field? "user_group_role_emails"
  end

  private

    def assert_membership_request_notification(user, &block)
      within "#notification-#{@notification.id}" do
        assert page.has_content? formatted_date
        assert page.has_content? user.name
        assert page.has_content? @nike_group.name
        assert page.has_content? notification_message(user, @nike_group)
        assert page.has_link?    "Go to request"
        assert page.has_link?    "Mark as read"

        yield if block_given?
      end
    end

    def formatted_date
      @notification.created_at.strftime("%d %b")
    end

    def notification_message(user, group)
      "New membership request from #{user.name} in #{group.name}."
    end

    def assert_membership_request_url
      assert page.current_url == user_membership_request_url(
        @phil, @notification)
    end

    def last_notification_for(user)
      "#notification-#{user.notifications.last.id}"
    end

    def mark_notification_as_read
      within "#notification-#{@notification.id}" do
        click_on "Mark as read"
      end
    end

    def refute_membership_request_notification(user)
      refute page.has_content? user.name
      refute page.has_content? notification_message(user, @nike_group)
    end

    def membership_request_from(user)
      "##{user.membership_requests.last.id}"
    end

    def last_membership_request
      "##{MembershipRequest.last.id}"
    end

    def request_membership_as_unnotifiable
      log_in_as @unnotifiable

      visit group_path(@nike_group)

      click_on "Request membership"
      fill_in "Message", with: "Hey! I'm Unnotifiable!"
      click_on "Send request"

      log_out_as @unnotifiable
    end

    def assert_regular_notifications
      click_on "Notifications"
      refute page.has_content? "There are no notifications"
    end
end
