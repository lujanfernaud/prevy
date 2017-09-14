require 'test_helper'

class EventsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @phil    = users(:phil)
    @penny   = users(:penny)
    @event   = events(:one)
    @address = addresses(:one)
    @event.build_address(@address.attributes)
  end

  test "author can delete event" do
    log_in_as(@phil)
    visit event_path(@event)

    assert_difference "Event.count", -1 do
      click_on "Delete event"
    end

    assert current_path, user_path(@phil)
    assert page.has_content? "deleted"
  end

  test "user can't delete other users' event" do
    log_in_as(@penny)
    visit event_path(@event)

    assert_not page.has_content? "Delete event"
  end
end
