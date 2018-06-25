require 'test_helper'

class EventsOrganizerTest < ActionDispatch::IntegrationTest
  test "user visits organizer" do
    stranger  = users(:stranger)
    group     = groups(:one)
    event     = events(:one)
    organizer = event.organizer

    log_in_as stranger

    visit group_event_path(group, event)

    click_on organizer.name

    assert current_path == event_attendee_path(event, organizer)
    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      click_on event.title
    end

    assert current_path == group_event_path(group, event)
  end
end
