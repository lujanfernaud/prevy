# frozen_string_literal: true

require 'test_helper'

class MembershipRequestsTest < ActionDispatch::IntegrationTest
  def setup
    @pennys_group = groups(:two)
    @penny    = users(:penny)
    @woodell  = users(:woodell)
    @stranger = users(:stranger)
    @message  = "Hey! I would love to be part :)"
  end

  test "user requests membership" do
    @woodell.notifications.destroy_all

    log_in_as @woodell

    visit group_path @pennys_group

    send_membership_request

    assert_membership_request_was_sent
    assert_membership_requests_link

    log_out

    #
    # Switch User
    #

    log_in_as @penny

    assert_notifications
    assert_membership_requests_link

    log_out

    #
    # Switch User
    #

    log_in_as @woodell

    go_to_membership_requests_for @woodell

    click_on "Cancel request"

    assert page.has_content? "Your membership request was deleted."
    refute_membership_requests_link

    log_out

    #
    # Switch User
    #

    log_in_as @penny

    refute_notifications
    refute_membership_requests_link
  end

  test "group owner accepts membership request" do
    @woodell.notifications.destroy_all

    send_membership_request_as @woodell

    #
    # Switch User
    #

    log_in_as @penny

    assert_notifications
    assert_membership_requests_link

    go_to_membership_requests_for @penny

    within last_membership_request do
      assert_received_membership_request

      click_on "Accept"
    end

    assert page.has_content? request_accepted_message_for @woodell

    refute_notifications
    refute_membership_requests_link

    log_out

    #
    # Switch User
    #

    log_in_as @woodell

    visit user_notifications_path @woodell

    assert page.has_content? accepted_membership_request_notification
  end

  test "group owner declines membership request" do
    @woodell.notifications.destroy_all

    send_membership_request_as @woodell

    #
    # Switch User
    #

    log_in_as @penny

    assert_notifications
    assert_membership_requests_link

    go_to_membership_requests_for @penny

    within last_membership_request do
      click_on "Decline"
    end

    assert page.has_content? "The membership request was deleted."

    refute_notifications
    refute_membership_requests_link

    log_out

    #
    # Switch User
    #

    log_in_as @woodell

    visit user_notifications_path @woodell

    assert page.has_content? declined_membership_request_notification

    click_on "Mark as read"

    refute page.has_content? declined_membership_request_notification
  end

  test "user has no membership requests" do
    log_in_as @stranger

    refute_notifications
    refute_membership_requests_link
  end

  private

    def send_membership_request
      click_on "Request membership"
      assert page.has_content? "Would you like to add a nice message?"
      fill_in "Message", with: @message
      click_on "Send request"
    end

    def send_membership_request_as(user, group = @pennys_group)
      log_in_as user
      visit group_path group
      send_membership_request
      log_out
    end

    def last_membership_request
      "##{MembershipRequest.last.id}"
    end

    def assert_membership_request_was_sent
      assert page.has_content? request_sent_message

      within ".group-membership" do
        assert page.has_content? "Membership requested"
      end

      go_to_membership_requests_for @woodell

      within last_membership_request do
        assert page.has_link?    @pennys_group.name
        assert page.has_content? @message
        assert page.has_link?    "Cancel request"
      end
    end

    def assert_received_membership_request
      assert page.has_link?    @woodell.name
      assert page.has_link?    @pennys_group.name
      assert page.has_content? @message
      assert page.has_link?    "Accept"
      assert page.has_link?    "Decline"
    end

    def request_sent_message
      "Your request has been sent. " \
        "You'll be notified when there's any change."
    end

    def request_accepted_message_for(user, group = @pennys_group)
      "#{user.name} was accepted as a member of #{group.name}."
    end

    def assert_membership_requests_link
      assert page.has_link?    "Membership requests"
      assert page.has_css?     ".badge-pill"
      assert page.has_content? /Membership requests \d/
    end

    def refute_membership_requests_link
      refute page.has_link?    "Membership requests"
      refute page.has_css?     ".badge-pill"
      refute page.has_content? /Membership requests \d/
    end

    def go_to_membership_requests_for(user)
      click_on user.name
      click_on "Membership requests"
    end

    def assert_notifications
      within ".btn-notifications" do
        assert page.has_css? ".badge-pill"
      end

      click_on "Notifications"
      assert page.has_content? new_membership_request_notification
    end

    def refute_notifications
      within ".btn-notifications" do
        refute page.has_css? ".badge-pill"
      end

      assert page.has_css? ".btn-notifications.disabled"
    end

    def new_membership_request_notification
      "New membership request from #{@woodell.name} in #{@pennys_group.name}."
    end

    def accepted_membership_request_notification
      "You have been accepted as a member of #{@pennys_group.name}!"
    end

    def declined_membership_request_notification
      "You membership request for #{@pennys_group.name} was declined."
    end
end
