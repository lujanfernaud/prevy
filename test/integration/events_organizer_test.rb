require 'test_helper'

class EventsOrganizerTest < ActionDispatch::IntegrationTest
  test "user visits organizer" do
    group     = groups(:one)
    event     = events(:one)
    organizer = event.organizer

    visit group_event_path(group, event)

    click_on organizer.name

    assert current_path == user_path(organizer)
    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      click_on event.title
    end

    assert current_path == group_event_path(group, event)
  end
end
