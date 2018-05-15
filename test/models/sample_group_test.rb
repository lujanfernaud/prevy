require 'test_helper'

class SampleGroupTest < ActiveSupport::TestCase
  GROUP_OWNER_COUNT = 1

  def setup
    stub_geocoder
  end

  test "creates group with sample members, organizer and event" do
    user = users(:stranger)

    SampleGroup.create_for_user(user)
    group = Group.last

    members_count = SampleUser.all.count
    organizers_count = group.organizers.count - GROUP_OWNER_COUNT
    members_with_role_count = members_count - organizers_count

    assert group.sample_group?
    assert_equal user, group.owner

    assert_equal SampleUser.all, group.members
    assert_equal members_with_role_count, group.members_with_role.count

    assert_equal 5, group.organizers.count
    assert_equal 1, group.events.count
  end
end
