require 'test_helper'

class SampleGroupTest < ActiveSupport::TestCase
  def setup
    stub_geocoder
  end

  test "creates group with sample members, organizer and event" do
    user = users(:stranger)
    SampleGroup.create_for_user(user)
    group = Group.last

    assert group.sample_group?
    assert_equal user, group.owner
    assert SampleUser.all.count, group.members.count
    assert_equal 5, group.organizers.count
    assert_equal 1, group.events.count
  end
end
