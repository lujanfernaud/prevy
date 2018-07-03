# frozen_string_literal: true

require 'test_helper'

class SampleGroupTest < ActiveSupport::TestCase
  GROUP_OWNER_COUNT = 1

  def setup
    stub_geocoder
  end

  test "creates group with sample members, organizers, topics and event" do
    user = users(:stranger)

    SampleGroup.create_for_user(user)
    group = Group.last

    sample_users_collection = SampleUser.collection_for_sample_group
    organizers_count        = group.organizers.size - GROUP_OWNER_COUNT
    members_with_role_count = sample_users_collection.size - organizers_count

    assert group.sample_group?
    assert_equal user, group.owner

    assert_equal sample_users_collection.size, group.members.size
    assert_equal members_with_role_count, group.members_with_role.size

    assert_equal 4, group.organizers.size
    assert_equal 1, group.events.size

    assert_equal 1, group.announcement_topics.size
    assert_equal 1, group.event_topics.size
    assert_equal 1, group.pinned_topics.size
    assert_equal 6, group.normal_topics.size

    assert user.group_points_amount(group)
  end

  test "all members have a group comments count" do
    user = users(:stranger)

    SampleGroup.create_for_user(user)
    group = Group.last

    members = group.members

    members.all? do |member|
      assert member.group_points_amount(group)
    end
  end
end
