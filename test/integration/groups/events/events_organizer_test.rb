# frozen_string_literal: true

require 'test_helper'

class EventsOrganizerTest < ActionDispatch::IntegrationTest
  def setup
    @stranger  = users(:stranger)
    @group     = groups(:one)
    @event     = events(:one)
    @organizer = @event.organizer

    @group.members << @stranger
  end

  test "user visits organizer" do
    log_in_as @stranger

    visit group_event_path(@group, @event)

    click_on @organizer.name

    assert_current_path event_attendee_path(@event, @organizer)
    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      click_on @event.title
    end

    assert_current_path group_event_path(@group, @event)
  end
end
