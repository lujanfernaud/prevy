require 'test_helper'

class SampleEventTest < ActiveSupport::TestCase
  def setup
    stub_geocoder

    @group = groups(:one)

    add_members_with_role
  end

  test "creates event with sample attendees and sample comments" do
    SampleEvent.create_for_group(@group)
    event = Event.last

    assert_equal @group.owner, event.organizer
    assert_not_empty event.attendees

    assert event.comments.count > 5
  end

  test "touches users after adding comments" do
    previous_updated_at = @group.members.pluck(:updated_at)

    SampleEvent.create_for_group(@group)

    updated_at = @group.members.reload.pluck(:updated_at)

    assert_not_equal previous_updated_at, updated_at
  end

  private

    def add_members_with_role
      @group.members.each do |user|
        user.add_role :member, @group
      end
    end
end
