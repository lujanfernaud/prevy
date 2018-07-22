# frozen_string_literal: true

require 'test_helper'

class FooterTest < ActionDispatch::IntegrationTest
  test "is shown in home page" do
    visit root_path

    assert page.has_css? footer_css
  end

  test "is not shown in sign up page" do
    visit new_user_registration_path

    assert_current_path new_user_registration_path

    assert_not page.has_css? footer_css
  end

  test "is not shown in sign up page with errors" do
    user = create :user, name: "Doris", email: "doris@test.test"

    visit new_user_registration_path

    fill_in "Name",  with: user.name
    fill_in "Email", with: user.email

    within "form" do
      click_on "Sign up"
    end

    assert_current_path "/users"

    assert_not page.has_css? footer_css
  end

  test "is not shown in log in page" do
    visit new_user_session_path

    assert_current_path new_user_session_path

    assert_not page.has_css? footer_css
  end

  test "is not shown in password recovery page" do
    visit new_user_password_path

    assert_current_path new_user_password_path

    assert_not page.has_css? footer_css
  end

  test "is not shown in request new confirmation page" do
    visit new_user_confirmation_path

    assert_current_path new_user_confirmation_path

    assert_not page.has_css? footer_css
  end

  test "is not shown in confirmation page" do
    stub_sample_content_for_new_users

    user = create :user, confirmation_token: 123456789
    confirmation_token_param = { confirmation_token: user.confirmation_token }

    log_in_as user

    visit user_confirmation_path(confirmation_token_param)

    assert_current_path user_confirmation_path(confirmation_token_param)

    assert_not page.has_css? footer_css
  end

  test "is not shown in account settings page" do
    user = users(:phil)

    log_in_as user

    visit edit_user_registration_path user

    assert_current_path edit_user_registration_path user

    assert_not page.has_css? footer_css
  end

  test "is not shown in profile settings page" do
    user = users(:phil)

    log_in_as user

    visit edit_user_path user

    assert_current_path edit_user_path user

    assert_not page.has_css? footer_css
  end

  test "is not shown in notifications settings page" do
    user = users(:phil)

    log_in_as user

    visit user_notification_settings_path user

    assert_current_path user_notification_settings_path user

    assert_not page.has_css? footer_css
  end

  test "is not shown in notifications index page" do
    user = users(:phil)

    log_in_as user

    visit user_notifications_path user

    assert_current_path user_notifications_path user

    assert_not page.has_css? footer_css
  end

  test "is not shown in profile page" do
    user = users(:phil)

    log_in_as user

    visit user_path user

    assert_current_path user_path user

    assert_not page.has_css? footer_css
  end

  test "is not shown in 'My groups'" do
    stub_sample_content_for_new_users

    user = create :user
    create :group, owner: user

    log_in_as user

    visit user_groups_path user

    assert_current_path user_groups_path user

    assert_not page.has_css? footer_css
  end

  test "is not shown in membership requests 'index'" do
    stub_sample_content_for_new_users

    user = create :user

    log_in_as user

    visit user_membership_requests_path user

    assert_current_path user_membership_requests_path user

    assert_not page.has_css? footer_css
  end

  test "is not shown in membership requests 'show'" do
    stub_sample_content_for_new_users

    user   = create :user
    group  = create :group, owner: user
    sender = create :user
    membership_request = create :membership_request, user: sender, group: group

    log_in_as user

    visit user_membership_request_path user, membership_request

    assert_current_path user_membership_request_path user, membership_request

    assert_not page.has_css? footer_css
  end

  test "is not shown in membership requests 'new'" do
    stub_sample_content_for_new_users

    user  = create :user
    group = create :group

    log_in_as user

    visit new_group_membership_request_path group

    assert_current_path new_group_membership_request_path group

    assert_not page.has_css? footer_css
  end

  test "is not shown in member profile" do
    stub_sample_content_for_new_users

    user   = create :user
    member = create :user
    group  = create :group, owner: user
    group.members << member

    log_in_as user

    visit group_member_path(group, member)

    assert_current_path group_member_path(group, member)

    assert_not page.has_css? footer_css
  end

  test "is not shown in attendee profile" do
    stub_sample_content_for_new_users

    user     = create :user
    attendee = create :user
    group    = create :group, owner: user
    group.members << attendee

    event = create :event, group: group, organizer: group.owner
    event.attendees << attendee

    log_in_as user

    visit event_attendee_path(event, attendee)

    assert_current_path event_attendee_path(event, attendee)

    assert_not page.has_css? footer_css
  end

  test "is not shown in invitations 'new'" do
    stub_sample_content_for_new_users

    user  = create :user
    group = create :group, owner: user

    log_in_as user

    visit new_group_invitation_path group

    assert_current_path new_group_invitation_path group

    assert_not page.has_css? footer_css
  end

  test "is not shown in invitations 'index'" do
    stub_sample_content_for_new_users

    user  = create :user
    group = create :group, owner: user

    log_in_as user

    visit group_invitations_path group

    assert_current_path group_invitations_path group

    assert_not page.has_css? footer_css
  end

  test "is not shown on 'create group unconfirmed' notice page" do
    stub_sample_content_for_new_users

    user = create :user

    log_in_as user

    click_on user.name
    click_on "Create group"

    assert_current_path create_group_unconfirmed_path

    assert_not page.has_css? footer_css
  end

  test "is not shown on 'hidden group' notice" do
    visit hidden_group_path

    assert_current_path hidden_group_path

    assert_not page.has_css? footer_css
  end

  private

    def footer_css
      "footer.footer"
    end
end
