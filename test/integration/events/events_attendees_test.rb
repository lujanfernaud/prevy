require 'test_helper'

class EventsAttendeesTest < ActionDispatch::IntegrationTest
  def setup
    @stranger = users(:stranger)
    @group    = groups(:one)
    @event    = events(:one)
    @attendee = @event.attendees.first
  end

  test "logged in user visits attendees" do
    attendees_count = @event.attendees.count

    visit_event_attendees_logged_in_as_stranger

    assert_breadcrumbs(@group, @event)

    assert page.has_content? @event.title
    assert page.has_content? "Attendees (#{attendees_count})"

    assert_attendees_links(@event)
  end

  test "attendee card shows comments number" do
    attendee_group_comments = @attendee.group_comments_number(@group)

    visit_event_attendees_logged_in_as_stranger

    within "#user-#{@attendee.id}" do
      assert page.has_content? attendee_group_comments
    end
  end

  test "logged out user visits attendees" do
    visit event_attendances_path(@event)

    assert page.has_content? "You are not authorized to perform this action"
    assert_equal current_path, root_path
  end

  test "user visit attendee" do
    visit_event_attendees_logged_in_as_stranger

    click_on @attendee.name

    assert current_path == user_path(@attendee.id)

    within ".breadcrumb" do
      assert page.has_link? "Attendees"
      click_on "Attendees"
    end

    assert current_path == event_attendances_path(@event)
  end

  private

    def visit_event_attendees_logged_in_as_stranger
      log_in_as @stranger

      visit event_attendances_path(@event)
    end

    def assert_breadcrumbs(group, event)
      assert page.has_css?  ".breadcrumb"
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
