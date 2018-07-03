# frozen_string_literal: true

require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users

    @phil  = create :user, :confirmed, name: "Phil"
    @group = create :group, owner: @phil
  end

  test "logged out user visits home page" do
    visit root_path

    assert_promotional_section
    refute_upcoming_events
    refute_user_groups
    assert_unhidden_groups
  end

  test "logged in user with events visits home page" do
    create_list :event, 7, group: @group

    log_in_as(@phil)

    visit root_path

    refute_promotional_section

    assert_upcoming_events do
      refute page.has_content? no_events
      assert page.has_link?    more_events
    end

    assert_user_groups do
      refute page.has_content? no_group_memberships
      assert_groups_for(@phil)
    end

    assert_unhidden_groups
  end

  test "logged in user clicks on event comments" do
    event = create :event, group: @group

    log_in_as(@phil)

    visit root_path

    within "#event-#{event.id}" do
      click_on "#{event.comments.size} comments"
    end

    assert_current_path group_event_path(@group, event)
  end

  test "logged in user clicks on group topics" do
    log_in_as(@phil)

    visit root_path

    within "#group-#{@group.id}" do
      click_on "#{@group.topics.size} topics"
    end

    assert_current_path group_topics_path(@group)
  end

  test "logged in user without upcoming events visits home page" do
    log_in_as(@phil)

    visit root_path

    refute_promotional_section

    assert_upcoming_events do
      assert page.has_content? no_events
      refute page.has_link?    more_events
    end

    assert_user_groups do
      refute page.has_content? no_group_memberships
      assert_groups_for(@phil)
    end

    assert_unhidden_groups
  end

  test "logged in user without groups visits home page" do
    carolyn = create :user, :confirmed, name: "Carolyn"

    log_in_as(carolyn)

    visit root_path

    refute_promotional_section

    assert_upcoming_events do
      assert page.has_content? membership_needed_to_see_events
      refute page.has_link?    more_events
    end

    assert_user_groups do
      assert page.has_content? no_group_memberships
    end

    assert_unhidden_groups
  end

  test "new and unconfirmed user visits home page" do
    unconfirmed = create :user, name: "Unconfirmed"

    log_in_as(unconfirmed)

    visit root_path

    assert_create_group_unconfirmed_button
  end

  private

    def assert_promotional_section
      assert page.has_content? promotional_message
      assert page.has_link? "Sign up and get started"
    end

    def refute_promotional_section
      refute page.has_content? promotional_message
      refute page.has_link? "Sign up and get started"
    end

    def promotional_message
      "Private Communities Around Events"
    end

    def assert_upcoming_events
      assert page.has_css? ".upcoming-events-container"

      within ".upcoming-events-container" do
        assert page.has_content? "Upcoming Events"
        yield if block_given?
      end
    end

    def refute_upcoming_events
      refute page.has_css? ".upcoming-events-container"
      refute page.has_content? "Upcoming Events"
    end

    def no_events
      "There are no upcoming events"
    end

    def membership_needed_to_see_events
      "You need to be a member of a group to see events here"
    end

    def more_events
      "See more upcoming events"
    end

    def assert_user_groups
      assert page.has_css? ".user-groups-container"

      within ".user-groups-container" do
        assert page.has_content? "Your Groups"
        yield if block_given?
        assert page.has_link? "Create group"
      end
    end

    def assert_groups_for(user)
      user.groups { |group| assert page.has_link? group.name }
    end

    def refute_user_groups
      refute page.has_css? ".user-groups-container"
      refute page.has_content? "Your Groups"
    end

    def no_group_memberships
      "You still don't have membership to any group."
    end

    def assert_unhidden_groups
      assert page.has_css? ".unhidden-groups-container"
      assert page.has_content? "Unhidden Groups"
    end
end
