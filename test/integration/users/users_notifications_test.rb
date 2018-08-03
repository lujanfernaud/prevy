# frozen_string_literal: true

require 'test_helper'

class UsersNotificationsTest < ActionDispatch::IntegrationTest
  def setup
    stub_geocoder

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

    refute_current_path user_notifications_path(@phil)
  end

  test "group owner visits notifications and accepts membership request" do
    stub_sample_content_for_new_users

    group              = create :group
    membership_request = create :membership_request, group: group
    receiver           = group.owner
    sender             = membership_request.user

    notification = create :notification,
      :membership_request_notification,
       message: membership_request_notification_message(sender, group),
       membership_request_id: membership_request.id,
       user: receiver

    log_in_as(receiver)

    click_notifications_button

    within "#notification-#{notification.id}" do
      assert page.has_content? formatted_date

      assert page.has_content? membership_request_notification_message(
        sender, group)

      assert page.has_link? "Go to request"
      assert page.has_link? "Mark as read"

      click_on "Go to request"
    end

    assert_current_path user_membership_request_path(
      receiver, membership_request)

    visit user_notifications_path(receiver)

    refute page.has_css?     "#notification-#{notification.id}"
    refute page.has_content? sender.name
    refute page.has_content? membership_request_notification_message(
      sender, group)

    click_user_button
    click_on "Membership requests"

    within membership_request_from(sender) do
      click_on "Accept"
    end

    log_out

    log_in_as(sender)

    click_notifications_button

    within last_notification_for(sender) do
      click_on "Go to group"
    end

    assert_current_path group_path(group)

    click_notifications_button

    assert page.has_content? no_notifications_message
  end

  test "user marks membership request notification as read" do
    request_membership_as_unnotifiable

    log_in_as(@phil)

    visit user_notifications_path(@phil)

    assert page.has_content? "membership request from Unnotifiable Stranger"

    within last_notification_for(@phil) do
      click_on "Mark as read"
    end

    refute page.has_content? "membership request from Unnotifiable Stranger"
  end

  test "user marks group membership notification as read" do
    request_membership_as_unnotifiable

    log_in_as(@phil)

    visit user_membership_requests_url(@phil)

    within last_membership_request do
      click_on "Accept"
    end

    log_out

    log_in_as(@unnotifiable)

    visit user_notifications_path(@unnotifiable)

    within last_notification_for(@unnotifiable) do
      click_on "Mark as read"
    end

    assert page.has_content? no_notifications_message
  end

  test "user marks group role notification as read" do
    @unnotifiable.add_role(:member, @nike_group)

    log_in_as(@phil)

    visit group_roles_path(@nike_group)

    within "#roles-user-#{@unnotifiable.id}" do
      click_on "Add organizer role"
    end

    log_out

    log_in_as(@unnotifiable)

    click_notifications_button

    within last_notification_for(@unnotifiable) do
      click_on "Mark as read"
    end

    assert page.has_content? no_notifications_message
  end

  test "user without notifications visits notifications" do
    log_in_as(@stranger)

    click_notifications_button

    assert page.has_content? no_notifications_message
  end

  test "user doesn't receive membership request email notifications" do
    request_membership_as_unnotifiable

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit user_membership_requests_url(@phil)

    within last_membership_request do
      click_on "Decline"
    end

    log_out

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

    log_out

    log_in_as(@unnotifiable)

    assert_regular_notifications
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "user doesn't receive group role email notifications" do
    @unnotifiable.add_role(:member, @nike_group)

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit group_roles_path(@nike_group)

    within "#roles-user-#{@unnotifiable.id}" do
      click_on "Add organizer role"
    end

    log_out

    log_in_as(@unnotifiable)

    assert_regular_notifications
    assert_equal 0, ActionMailer::Base.deliveries.size

    log_out

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit group_roles_path(@nike_group)

    within "#roles-user-#{@unnotifiable.id}" do
      click_on "Remove organizer role"
    end

    log_out

    log_in_as(@unnotifiable)

    assert_regular_notifications
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "user doesn't receive events email notifications" do
    @nike_group.members << @unnotifiable
    event = events(:one)

    log_in_as(@phil)
    ActionMailer::Base.deliveries.clear

    visit group_url(@nike_group)

    create_event(event)

    log_out

    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "user doesn't receive group invitation email notifications" do
    stub_sample_content_for_new_users

    user  = create :user, :no_emails
    group = create :group

    log_in_as(group.owner)

    visit group_url(group)

    click_on "Invite someone"

    fill_in "First name", with: user.name
    fill_in "Email",      with: user.email

    ActionMailer::Base.deliveries.clear

    click_on "Invite"

    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "user marks all notifications as read" do
    stub_sample_content_for_new_users

    receiver = create :user
    create_list :notification, 5, user: receiver

    log_in_as(receiver)

    visit user_notifications_path(receiver)

    click_on "Mark all as read"

    assert_current_path user_notifications_path(receiver)
    assert page.has_content? no_notifications_message
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

    assert_checked_fields

    uncheck_fields

    click_on "Update"

    assert page.has_content? "updated"

    assert_unchecked_fields
  end

  private

    def formatted_date
      @notification.created_at.strftime("%d %b")
    end

    def membership_request_notification_message(user, group)
      "New membership request from #{user.name} in #{group.name}."
    end

    def last_notification_for(user)
      "#notification-#{user.notifications.last.id}"
    end

    def membership_request_from(user)
      "#membership-request-#{user.membership_requests.last.id}"
    end

    # TODO: Extract to integration_support.
    def last_membership_request
      "#membership-request-#{MembershipRequest.last.id}"
    end

    def request_membership_as_unnotifiable
      log_in_as @unnotifiable

      visit group_path(@nike_group)

      click_on "Request membership"
      fill_in "Message", with: "Hey! I'm Unnotifiable!"
      click_on "Send request"

      log_out
    end

    def assert_regular_notifications
      click_notifications_button
      refute page.has_content? no_notifications_message
    end

    def no_notifications_message
      "There are no notifications"
    end

    def assert_checked_fields
      checkbox_fields.each do |field|
        assert page.has_checked_field? field
      end
    end

    def uncheck_fields
      checkbox_fields.each do |field|
        uncheck field
      end
    end

    def assert_unchecked_fields
      checkbox_fields.each do |field|
        assert page.has_no_checked_field? field
      end
    end

    def checkbox_fields
      [
        "user_membership_request_emails",
        "user_group_membership_emails",
        "user_group_role_emails",
        "user_group_event_emails",
        "user_group_announcement_emails",
        "user_group_invitation_emails"
      ]
    end

    def create_event(event)
      click_on "Create event"
      fill_in_valid_information(event)
      fill_in_valid_address(event)
      click_on_create_event
    end

    def fill_in_valid_information(event)
      fill_in "Title", with: event.title
      fill_in_description(event.description)
    end

    def fill_in_valid_address(event)
      fill_in "Address 1", with: event.street1
      fill_in "Address 2", with: event.street2
      fill_in "City",      with: event.city
      fill_in "State",     with: event.state
      fill_in "Post code", with: event.post_code
      select  "Spain",     from: "Country"
    end

    def click_on_create_event
      within "form" do
        click_on "Create event"
      end
    end
end
