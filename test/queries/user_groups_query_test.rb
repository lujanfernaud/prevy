# frozen_string_literal: true

require 'test_helper'

class UserGroupsQueryTest < ActiveSupport::TestCase
  test "returns groups where the user is owner or has membership" do
    stub_sample_content_for_new_users

    user        = create :user, :confirmed
    owned_group = create :group, owner: user
    groups      = create_list :group, 4
    all_groups  = [owned_group] + groups

    groups.each do |group|
      group.members << user
    end

    result = UserGroupsQuery.call(user)

    assert_equal all_groups.sort, result.sort
  end
end
