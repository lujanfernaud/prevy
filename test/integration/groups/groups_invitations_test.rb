# frozen_string_literal: true

require 'test_helper'

class InvitationsCreationTest < ActionDispatch::IntegrationTest
  def setup
    @group = create :group
    @scott = build_stubbed :user, name: "Scott", email: "scott@test.test"

    stub_sample_content_for_new_users
  end

  test "group owner invites person" do
    log_in_as @group.owner

    visit group_path(@group)

    click_on "Invite someone"

    fill_in_details_for @scott

    click_on "Invite"

    assert_not page.has_content? "error"
    assert_current_path group_invitations_path(@group)
  end

  test "group owner invites person without filling in the name" do
    log_in_as @group.owner

    visit new_group_invitation_path(@group)

    fill_in "Email", with: @scott.email

    click_on "Invite"

    assert page.has_content? "error"
    assert page.has_content? "Name can't be blank"
  end

  test "group owner invites person that already has a group invitation" do
    create :group_invitation, group: @group, email: @scott.email

    log_in_as @group.owner

    visit new_group_invitation_path(@group)

    fill_in_details_for @scott

    click_on "Invite"

    assert page.has_content? "error"
    assert page.has_content? "Email is already in sent invitations"
  end

  test "group owner invites existing group member" do
    user = create :user
    @group.members << user

    log_in_as @group.owner

    visit group_invitations_path(@group)

    click_on "Invite someone"

    fill_in_details_for user

    click_on "Invite"

    assert page.has_content? "error"
    assert page.has_content? "User is already a group member"
  end

  test "unregistered person visits hidden group following invitation link" do
    group = create :group, hidden: true
    invitation = create :group_invitation, group: group, sender: group.owner

    visit group_path group, token: invitation.token

    within ".group-buttons-box" do
      assert page.has_content? "You've been invited!"
      assert page.has_content? "Would you like to be part?"
      assert page.has_link?    "Yes!"
    end

    assert page.has_css? ".invitee-container"
  end

  test "unregistered invited person joins group" do
    users = SampleUser.select_random_users(10)
    @group.members << users
    @invitation = create :group_invitation, group: @group, sender: @group.owner

    visit group_path(@group, token: @invitation.token)

    # Topics section is not shown for invitees if there are no topics.
    assert_not page.has_css? ".latest-topics-container"
    assert page.has_css?     ".members-container"
    assert page.has_css?     ".invitee-container"

    within ".group-buttons-box" do
      click_on "Yes!"
    end

    assert_current_path user_confirmation_path(invited_member_params)

    fill_in "Password", with:              "password"
    fill_in "Password confirmation", with: "password"

    click_on "Confirm"

    assert_current_path group_path(@group, invited: true)

    assert_not page.has_css? ".alert"
    assert page.has_content? "Welcome to the group!"
  end

  test "registered invited user joins group" do
    user = create :user, :confirmed

    create_invitation_as_group_owner_for user

    log_in_as user

    click_on "Notifications 1"

    within last_notification do
      assert page.has_content? notification.message
      click_on "Go to group"
    end

    within ".group-buttons-box" do
      click_on "Yes!"
    end

    assert_current_path group_path(@group, invited: true)

    assert_not page.has_css? ".alert"
    assert page.has_content? "Welcome to the group!"
  end

  test "invitations index breadcrumbs" do
    log_in_as @group.owner

    visit new_group_invitation_path(@group)

    within ".breadcrumb" do
      assert page.has_link?    @group.name
      assert page.has_content? "Invitations"
    end
  end

  test "new invitation breadcrumbs" do
    log_in_as @group.owner

    visit new_group_invitation_path(@group)

    within ".breadcrumb" do
      assert page.has_link?    @group.name
      assert page.has_link?    "Invitations"
      assert page.has_content? "Invite someone"

      click_on "Invitations"
    end

    assert_current_path group_invitations_path(@group)
  end

  private

    def fill_in_details_for(user)
      fill_in "First name", with: user.name
      fill_in "Email",      with: user.email
    end

    def invited_member_params
      {
        confirmation_token: @invitation.token,
        group_id: @group.id,
        invited: true
      }
    end

    def create_invitation_as_group_owner_for(user)
      log_in_as @group.owner

      visit new_group_invitation_path(@group)

      fill_in_details_for(user)

      click_on "Invite"

      log_out
    end

    def last_notification
      "#notification-#{notification.id}"
    end

    def notification
      @_notification ||= Notification.last
    end
end
