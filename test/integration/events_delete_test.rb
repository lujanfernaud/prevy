require 'test_helper'

class EventsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:phil)
    @event = events(:one)
    @invalid_user = users(:penny)
  end

  test "author can delete event" do
    log_in_as(@user)
    visit event_path(@event)

    assert_difference "Event.count", -1 do
      click_on "Delete event"
    end

    assert current_path, user_path(@user)
    assert page.has_content? "deleted"
  end

  test "user can't delete other users' event" do
    log_in_as(@invalid_user)
    visit event_path(@event)

    assert_not page.has_content? "Delete event"
  end
end
