require 'test_helper'

class NewUsersBlankStateTest < ActionDispatch::IntegrationTest
  def setup
    stub_geocoder
  end

  test "new user visits sample group" do
    log_in_as(new_user)

    click_on sample_group_name

    assert page.has_content? "Welcome to #{new_user.name}'s group!"
    assert_organizers
    assert_members
    assert page.has_link? sample_event_name
  end

  test "new user visits sample event" do
    log_in_as(new_user)

    click_on sample_event_name

    assert page.has_content? "This is how your event could look like."
    assert_attendees
  end

  test "new user creates a group" do
    prepare_javascript_driver

    log_in_as(new_user)

    click_on sample_group_name
    click_on "Click here to create your first group!"

    fill_in_group_details_with name: "Urban Sketchers"
    click_on_create_group

    visit root_path

    refute_page_has_sample_content
    assert page.has_link? "Urban Sketchers"
  end

  test "new user becomes a member of a group" do
    nike_group = groups(:one)

    log_in_as(new_user)

    visit group_path(nike_group)
    send_membership_request

    log_out_as(new_user)

    group_owner_accepts_membership_request_for(nike_group)

    log_in_as(new_user)

    refute_page_has_sample_content
  end

  private

    def sample_group_name
      "Your group"
    end

    def sample_event_name
      "Your event"
    end

    def assert_organizers
      within ".organizers-preview" do
        group_organizers.last(3).each do |organizer|
          assert page.has_link? organizer.name, count: 1
        end
      end
    end

    def group_organizers
      @group_organizers ||= new_user.sample_group.organizers
    end

    def assert_members
      within ".members-preview" do
        assert page.has_content? group_members.count
      end

      assert page.has_css? ".member-box", count: 12
    end

    def group_members
      @group_members ||= new_user.sample_group.members_with_role
    end

    def assert_attendees
      attendees_number = group_members.count

      within ".attendees-preview" do
        assert page.has_content? attendees_number
        assert page.has_link?    "See all attendees"
      end
    end

    def fill_in_group_details_with(name:)
      fill_in "Name",     with: name
      fill_in "Location", with: Faker::Address.city
      fill_in_description(Faker::Lorem.paragraph)

      attach_valid_image_for "group_image"

      choose "group_hidden_false"
      choose "group_all_members_can_create_events_false"
    end

    def click_on_create_group
      within "form" do
        click_on "Create group"
      end
    end

    def refute_page_has_sample_content
      refute page.has_link? sample_event_name
      refute page.has_link? sample_group_name
    end

    def send_membership_request
      click_on "Request membership"
      assert page.has_content? "Would you like to add a nice message?"
      fill_in "Message", with: "Hey!"
      click_on "Send request"
    end

    def group_owner_accepts_membership_request_for(group)
      log_in_as(group.owner)
      accept_membership_request_as(group.owner)
      log_out_as(group.owner)
    end

    def accept_membership_request_as(user)
      click_on user.name
      click_on "Membership requests"

      within last_membership_request do
        click_on "Accept"
      end
    end

    def last_membership_request
      "##{MembershipRequest.last.id}"
    end
end
