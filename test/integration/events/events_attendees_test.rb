require 'test_helper'

class EventsAttendeesTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users

    @stranger = create :user, :confirmed, name: "Stranger"
    attendees = build_list :user, 10, :confirmed
    @attendee = attendees.first

    @group = create :group
    @event = create :event, group: @group

    @group.members << [@stranger] + attendees
    @event.attendees << attendees
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

  test "non-member user visits attendees" do
    onitsuka = users(:onitsuka)

    log_in_as onitsuka

    visit event_attendees_path(@event)

    assert_equal current_path, root_path
  end

  test "logged out user visits attendees" do
    visit event_attendees_path(@event)

    assert_equal current_path, new_user_registration_path
  end

  test "user visit attendee" do
    visit_event_attendees_logged_in_as_stranger

    click_on @attendee.name

    assert_current_path event_attendee_path(@event, @attendee)

    within ".breadcrumb" do
      assert page.has_link? "Attendees"
      click_on "Attendees"
    end

    assert_current_path event_attendees_path(@event)
  end

  private

    def visit_event_attendees_logged_in_as_stranger
      log_in_as @stranger

      visit event_attendees_path(@event)
    end

    def assert_breadcrumbs(group, event)
      assert page.has_css?  ".breadcrumb"
      assert page.has_link? event.title

      within ".breadcrumb" do
        click_on event.title
        assert_current_path group_event_path(group, event)
      end

      click_on "See all attendees"
      assert_current_path event_attendees_path(event)
    end

    def assert_attendees_links(event)
      event.attendees.map(&:name).each do |name|
        assert page.has_link? name
      end
    end
end
