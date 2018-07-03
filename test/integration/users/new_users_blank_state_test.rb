# frozen_string_literal: true

require 'test_helper'

class NewUsersBlankStateTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport
  include CommentsIntegrationSupport

  def setup
    stub_geocoder

    @user = fake_user
    @user.save!
  end

  test "new user has sample membership request" do
    log_in_as(@user)

    assert page.has_content? "Notifications 1"

    click_on "Notifications 1"

    assert page.has_content? sample_group_name
  end

  test "new user accepts sample membership request" do
    request_user = @user.received_requests.first

    log_in_as(@user)

    visit group_members_path(@user.sample_group)
    refute page.has_link? request_user.name

    visit user_membership_requests_path(@user)

    click_on "Accept"

    visit group_members_path(@user.sample_group)

    assert page.has_link? request_user.name
  end

  test "new user visits sample group" do
    log_in_as(@user)

    click_on sample_group_name

    assert page.has_content? "Welcome to #{@user.name}'s group!"
    assert_members
    assert page.has_link? sample_event_name
  end

  test "new user creates topic in sample group" do
    log_in_as(@user)

    click_on sample_group_name

    submit_new_topic_with "Test topic", "This is the body of the test topic."
  end

  test "new user comments topic in sample group" do
    prepare_javascript_driver

    group = @user.groups.first
    topic = group.topics.sample

    log_in_as(@user)

    visit group_topic_path(group, topic)

    submit_new_comment_with "This is great!"

    assert page.has_content? "New comment created."
  end

  test "new user visits sample event" do
    log_in_as(@user)

    click_on sample_event_name

    assert page.has_content? "This is how your event could look like."
    assert page.has_content? "Would you like to attend?"
    assert_attendees

    click_on "Attend"

    assert page.has_content? "Yay! You are attending this event!"
    assert page.has_link?    "Cancel attendance"
  end

  test "new and confirmed user creates a group" do
    prepare_javascript_driver

    user = fake_user(confirmed_at: Time.zone.now - 1.day)
    user.save!

    log_in_as(user)

    visit new_group_path

    fill_in_group_details_with name: "Urban Sketchers"
    click_on_create_group

    visit root_path

    refute_page_has_sample_content
    assert page.has_link? "Urban Sketchers"
  end

  test "new user becomes a member of a group" do
    nike_group = groups(:one)

    log_in_as(@user)

    visit group_path(nike_group)
    send_membership_request

    log_out

    group_owner_accepts_membership_request_for(nike_group)

    log_in_as(@user)

    refute_page_has_sample_content
  end

  private

    def admin_name
      User.where(admin: true).first.name
    end

    def sample_group_name
      "Sample Group"
    end

    def sample_event_name
      "Sample Event"
    end

    def group_organizers
      @group_organizers ||= @user.sample_group.organizers
    end

    def assert_members
      within ".members-preview" do
        assert page.has_content? group_members.size
      end

      assert page.has_css? ".user-box"
    end

    def group_members
      @group_members ||= @user.sample_group.members_with_role
    end

    def assert_attendees
      attendees_number = group_members.size

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
      log_out
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
