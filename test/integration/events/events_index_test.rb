require 'test_helper'

class EventsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @phil = users(:phil)
    @onitsuka = users(:onitsuka)
  end

  test "user with events visits events index" do
    log_in_as(@phil)

    visit user_events_path(@phil)

    assert page.has_css? ".box", count: 15
  end

  test "user without events visits events index" do
    log_in_as(@onitsuka)

    visit user_events_path(@onitsuka)

    refute page.has_css?     ".box"
    assert page.has_content? "There are no upcoming events"
  end

  test "user visits group events index" do
    group = groups(:one)

    log_in_as(@phil)

    visit group_events_path(group)

    within ".breadcrumb" do
      assert page.has_link?    group.name
      assert page.has_content? "Events"
    end

    assert page.has_content? "Events"
    assert page.has_css?     ".box"
  end
end
