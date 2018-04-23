require 'test_helper'

class SampleEventTest < ActiveSupport::TestCase
  def setup
    stub_geocoder
  end

  test "creates event with sample attendees" do
    group = Group.last
    SampleEvent.build_for_group(group)
    event = Event.last

    assert event.organizer, group.owner
    assert event.attendees, group.members
  end
end
