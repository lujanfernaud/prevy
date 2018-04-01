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

    refute page.has_css? ".box"
    assert page.has_content? "There are no upcoming events"
  end
end
