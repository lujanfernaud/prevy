# frozen_string_literal: true

require 'test_helper'

class EventsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @phil    = users(:phil)
    @penny   = users(:penny)
    @group   = groups(:one)
    @event   = events(:one)
    @address = addresses(:one)
    @event.build_address(@address.attributes)
  end

  test "event organizer can delete event" do
    log_in_as(@phil)
    visit group_event_path(@group, @event)

    assert page.has_content? @event.title

    click_on "Edit event"
    click_on "Delete event"

    assert page.has_current_path? group_path(@group)
    assert page.has_content? "Event deleted"
    refute page.has_content? @event.title
  end
end
