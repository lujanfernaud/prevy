require 'test_helper'

class EventsShowTest < ActionDispatch::IntegrationTest
  test "logged in user visits event" do
    penny = users(:penny)
    group = groups(:one)
    event = EventDecorator.new(events(:one))

    log_in_as(penny)
    visit group_event_path(group, event)

    assert_event_information(event)
    assert_comments
    assert_attendees_preview(event)
    assert_quick_access

    refute page.has_link?    "Edit event"
    assert page.has_content? "Would you like to attend?"
    assert page.has_link?    "Attend"

    assert_attendees(event)
  end

  test "logged out user visits event" do
    group = groups(:one)
    event = EventDecorator.new(events(:one))

    visit group_event_path(group, event)

    assert page.has_content? "You are not authorized to perform this action"

    assert_equal current_path, root_path
  end

  test "event organizer visits event" do
    phil  = users(:phil)
    group = groups(:one)
    event = events(:one)

    log_in_as(phil)
    visit group_event_path(group, event)

    assert page.has_link?    "Edit event"
    refute page.has_content? "Would you like to attend?"
    refute page.has_link?    "Attend"
  end

  test "user attends and cancels attendance" do
    group = groups(:one)
    event = events(:one)
    penny = users(:penny)
    penny.add_role :member, group

    log_in_as(penny)
    visit group_event_path(group, event)

    click_on "Attend"

    assert page.has_content? "Yay! You are attending this event!"
    assert page.has_content? "Cancel attendance"

    click_on "Cancel attendance"

    assert page.has_content? "Your attendance to this event " \
                             "has been cancelled."
    assert page.has_link?    "Attend"
  end

  test "website url is not shown if the event has no website" do
    group = groups(:one)
    event = events(:two)

    visit group_event_path(group, event)

    refute page.has_link? "https://"
  end

  private

    def assert_event_information(event)
      event_information_attributes(event).each do |attribute_data|
        assert page.has_content? attribute_data
      end
    end

    def event_information_attributes(event)
      [
        event.title,
        event.start_date_prettyfied,
        event.full_address,
        event.website,
        event.description
      ]
    end

    def assert_comments
      assert page.has_css? ".comments-container"
      assert page.has_css? "form#new_topic_comment"
    end

    def assert_attendees_preview(event)
      attendees_number = event.attendees.count

      within ".attendees-preview" do
        assert page.has_content? "Attendees (#{attendees_number})"
        assert page.has_content? "See all attendees"
      end
    end

    def assert_quick_access
      within ".quick-access" do
        assert page.has_link? "See location in map"
      end
    end

    def assert_attendees(event)
      within ".attendees-container" do
        assert page.has_content? "Attendees (#{event.attendees.count})"
        assert page.has_css?     ".attendee-box"
      end
    end
end
