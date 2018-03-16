require 'test_helper'

class EventsShowTest < ActionDispatch::IntegrationTest
  test "user visits event" do
    penny     = users(:penny)
    group     = groups(:one)
    event     = events(:one)
    attendees = event.attendees.count

    log_in_as(penny)
    visit group_event_path(group, event)

    within ".breadcrumb" do
      assert page.has_link? group.name
      assert page.has_content? event.title
    end

    assert_event_information(event)

    assert page.has_content? "Attendees (#{attendees})"
    assert page.has_content? "See all attendees"

    assert page.has_content? "Would you like to attend?"
    assert page.has_link?    "Attend"
  end

  test "user attends and cancels attendance" do
    penny = users(:penny)
    group = groups(:one)
    event = events(:one)

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

  test "event organizer does not see 'attend' button" do
    phil  = users(:phil)
    group = groups(:one)
    event = events(:one)

    log_in_as(phil)
    visit group_event_path(group, event)

    refute page.has_content? "Would you like to attend?"
    refute page.has_link?    "Attend"
  end

  test "website url is not shown if the event has no website" do
    group = groups(:one)
    event = events(:two)

    visit group_event_path(group, event)

    refute page.has_link? "https://"
  end

  private

    def assert_event_information(event)
      assert page.has_content? event.title
      assert page.has_content? event.start_date_prettyfied
      assert page.has_content? event.full_address
      assert page.has_content? event.website
      assert page.has_content? event.description
    end
end
