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
    log_in_as @woodell

    visit group_path @pennys_group

    send_membership_request do
      assert page.has_content? "Would you like to add a nice message?"
    end

    assert page.has_content? request_sent_message

    within ".group-membership" do
      assert page.has_content? "Membership requested"
    end

    go_to_membership_requests_for @woodell

    assert page.has_link?    @pennys_group.name
    assert page.has_content? @message
    assert page.has_link?    "Cancel request"

    click_on "Cancel request"

    assert page.has_content? request_deleted_message
  end

  test "group owner accepts membership request" do
    send_membership_request_as @woodell

    log_in_as @penny

    assert_membership_requests_notification_pill

    go_to_membership_requests_for @penny

    within last_membership_request do
      assert page.has_link?    @woodell.name
      assert page.has_link?    @pennys_group.name
      assert page.has_content? @message
      assert page.has_link?    "Accept"
      assert page.has_link?    "Decline"

      click_on "Accept"
    end

    refute_membership_requests_notification_pill

    assert page.has_content? request_accepted_message_for @woodell
  end

  test "group owner declines membership request" do
    send_membership_request_as @woodell

    log_in_as @penny

    go_to_membership_requests_for @penny

    within last_membership_request do
      click_on "Decline"
    end

    assert page.has_content? request_deleted_message
  end

  test "user has no membership requests" do
    log_in_as @stranger

    refute_membership_requests_notification_pill

    go_to_membership_requests_for @stranger

    assert page.has_content? "There are no membership requests."
  end

  private

    def send_membership_request_as(user, group = @pennys_group)
      log_in_as user

      visit group_path group

      send_membership_request

      log_out_as user
    end

    def send_membership_request(&block)
      click_on "Request membership"

      yield if block_given?

      fill_in "Message", with: @message
      click_on "Send request"
    end

    def last_membership_request
      "##{MembershipRequest.last.id}"
    end

    def request_sent_message
      "Your request has been sent. " \
        "You'll be notified when there's any change."
    end

    def request_accepted_message_for(user, group = @pennys_group)
      "#{user.name} was accepted as a member of #{group.name}."
    end

    def request_deleted_message
      "The membership request was deleted."
    end

    def assert_membership_requests_notification_pill
      assert page.has_css? ".badge-pill"
      assert page.has_content? /Membership requests \d/
    end

    def refute_membership_requests_notification_pill
      refute page.has_css? ".badge-pill"
      refute page.has_content? /Membership requests \d/
    end

    def go_to_membership_requests_for(user)
      click_on user.name
      click_on "Membership requests"
    end
end
