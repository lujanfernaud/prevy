require 'test_helper'

class EventsAttendancesTest < ActionDispatch::IntegrationTest
  def setup
    @group = groups(:one)
    @event = events(:one)
    @user  = users(:penny)
    @user.add_role :member, @group
  end

  test "user not logged in can't attend an event" do
    visit group_event_path(@group, @event)

    assert page.has_no_link? "Attend"
  end

  test "user can attend an event" do
    log_in_as(@user)
    visit group_event_path(@group, @event)

    click_on "Attend"

    assert page.has_content? "You are attending this event!"
    assert page.has_link? "Cancel attendance"
  end

  test "user can cancel it's attendance to an event" do
    log_in_as(@user)
    visit group_event_path(@group, @event)

    click_on "Attend"
    click_on "Cancel attendance"

    assert page.has_content? "has been cancelled"
    assert page.has_link? "Attend"
  end
end
