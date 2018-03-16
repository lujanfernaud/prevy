require 'test_helper'

class EventsAttendeesTest < ActionDispatch::IntegrationTest
  test "user visits attendees" do
    group     = groups(:one)
    event     = events(:one)
    attendees = event.attendees.count

    visit event_attendances_path(event)

    assert_breadcrumbs(group, event)

    assert page.has_content? event.title
    assert page.has_content? "Attendees (#{attendees})"

    assert_attendees_links(event)
  end

  test "user visit attendee" do
    event    = events(:one)
    attendee = event.attendees.first

    visit event_attendances_path(event)

    click_on attendee.name

    assert current_path == user_path(attendee)

    within ".breadcrumb" do
      assert page.has_link? "Attendees"
      click_on "Attendees"
    end

    assert current_path == event_attendances_path(event)
  end

  private

    def assert_breadcrumbs(group, event)
      assert page.has_css?  ".breadcrumb"
      assert page.has_link? "Events"
      assert page.has_link? event.title

      within ".breadcrumb" do
        click_on event.title
        assert current_path == group_event_path(group, event)
      end

      click_on "See all attendees"
      assert current_path == event_attendances_path(event)
    end

    def assert_attendees_links(event)
      event.attendees.map(&:name).each do |name|
        assert page.has_link? name
      end
    end
end
