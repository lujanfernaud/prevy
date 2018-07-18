# frozen_string_literal: true

require 'test_helper'

class SampleGroupCreatorTest < ActiveSupport::TestCase
  TOTAL_ORGANIZERS = SampleGroupCreator::TOTAL_ORGANIZERS
  GROUP_OWNER      = 1
  ORGANIZERS_COUNT = TOTAL_ORGANIZERS - GROUP_OWNER

  def setup
    stub_sample_content_for_new_users
  end

  test "creates group with sample content" do
    user = create :user, :confirmed

    SampleGroupCreator.call(user)
    group = Group.last

    sample_users_collection = SampleUser.collection_for_sample_group
    members_count           = sample_users_collection.size

    assert group.sample_group?
    assert_equal user, group.owner

    assert_equal members_count, group.members.size
    assert_equal group.members.size, group.members_count
    assert_equal members_count - ORGANIZERS_COUNT, group.members_with_role.size

    assert_equal TOTAL_ORGANIZERS, group.organizers.size
  end

  test "returns created group" do
    user = create :user, :confirmed

    result = SampleGroupCreator.call(user)
    group  = Group.last

    assert_equal group, result
  end
end
