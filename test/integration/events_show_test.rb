require 'test_helper'

class EventsShowTest < ActionDispatch::IntegrationTest
  test "logged out user visits event" do
    event     = events(:one)
    attendees = event.attendees.count

    visit event_path(event)

    assert page.has_content? event.title
    assert page.has_content? event.start_date_prettyfied
    assert page.has_content? event.full_address
    assert page.has_content? event.website
    assert page.has_content? event.description

    assert page.has_content? "Attendees (#{attendees})"
    assert page.has_link?    "See all attendees"

    refute page.has_content? "Would you like to attend?"
    refute page.has_link?    "Attend"
  end

  test "logged in user visits event" do
    penny     = users(:penny)
    event     = events(:one)
    attendees = event.attendees.count

    log_in_as(penny)
    visit event_path(event)

    assert page.has_content? event.title
    assert page.has_content? event.start_date_prettyfied
    assert page.has_content? event.full_address
    assert page.has_content? event.website
    assert page.has_content? event.description

    assert page.has_content? "Attendees (#{attendees})"
    assert page.has_content? "See all attendees"

    assert page.has_content? "Would you like to attend?"
    assert page.has_link?    "Attend"
  end

  test "logged in user attends and cancels attendance" do
    penny = users(:penny)
    event = events(:one)

    log_in_as(penny)
    visit event_path(event)

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
    event = events(:one)

    log_in_as(phil)
    visit event_path(event)

    refute page.has_content? "Would you like to attend?"
    refute page.has_link?    "Attend"
  end

  test "website url is not shown if the event has no website" do
    event = events(:two)

    visit event_path(event)

    refute page.has_link? "https://"
  end
end
