require 'test_helper'

class SampleEventTest < ActiveSupport::TestCase
  def setup
    stub_geocoder
    @group = Group.last
  end

  test "creates event with sample attendees" do
    add_members_with_role

    SampleEvent.build_for_group(@group)
    event = Event.last

    assert_equal event.organizer, @group.owner
    assert_equal event.attendees, @group.members
  end

  private

    def add_members_with_role
      @group.members.each do |user|
        user.add_role :member, @group
      end
    end
end
