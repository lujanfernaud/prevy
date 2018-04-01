require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  def setup
    @phil = users(:phil)
    @onitsuka = users(:onitsuka)
  end

  test "logged out user visits home page" do
    visit root_path

    refute_upcoming_events
    assert_unhidden_groups
  end

  test "logged in user visits home page" do
    log_in_as(@phil)

    visit root_path

    assert_upcoming_events
    refute page.has_content? "There are no upcoming events"
    assert page.has_link? "See more upcoming events"
    assert_unhidden_groups
  end

  test "logged in user without upcoming events visits home page" do
    log_in_as(@onitsuka)

    visit root_path

    assert_upcoming_events
    assert page.has_content? "There are no upcoming events"
    assert_unhidden_groups
  end

  private

    def assert_upcoming_events
      assert page.has_css? ".upcoming-events-container"
      assert page.has_content? "Upcoming Events"
    end

    def refute_upcoming_events
      refute page.has_css? ".upcoming-events-container"
      refute page.has_content? "Upcoming Events"
    end

    def assert_unhidden_groups
      assert page.has_css? ".unhidden-groups-container"
      assert page.has_content? "Unhidden Groups"
    end
end
