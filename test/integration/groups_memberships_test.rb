require 'test_helper'

class GroupsMembershipsTest < ActionDispatch::IntegrationTest
  def setup
    @phil     = users(:phil)
    @stranger = users(:stranger)
    @onitsuka = users(:onitsuka)
    @nike     = groups(:one)
    @kyoto    = groups(:kyoto)
  end

  test "member is added to group where all members can create events" do
    send_membership_request_as(@stranger, group: @nike)
    accept_membership_request_as(@phil)

    log_in_as(@stranger)

    visit group_path(@nike)

    assert page.has_link? "Create event"
  end

  test "member is added to group where not all members can create events" do
    send_membership_request_as(@stranger, group: @kyoto)
    accept_membership_request_as(@onitsuka)

    log_in_as(@stranger)

    visit group_path(@kyoto)

    refute page.has_link? "Create event"
  end

  private

    def send_membership_request_as(user, group:)
      log_in_as(user)
      visit group_path(group)
      send_membership_request
      log_out_as(user)
    end

    def send_membership_request
      click_on "Request membership"
      fill_in  "Message", with: @message
      click_on "Send request"
    end

    def accept_membership_request_as(user)
      log_in_as(user)

      go_to_membership_requests_for(user)

      within last_membership_request do
        click_on "Accept"
      end

      log_out_as(user)
    end

    def go_to_membership_requests_for(user)
      click_on user.name
      click_on "Membership requests"
    end

    def last_membership_request
      "##{MembershipRequest.last.id}"
    end
end
