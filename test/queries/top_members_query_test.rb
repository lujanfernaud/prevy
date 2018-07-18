# frozen_string_literal: true

require 'test_helper'

class TopMembersQueryTest < ActiveSupport::TestCase
  test "#top_members" do
    stub_sample_content_for_new_users

    users = create_list :user, 12, :confirmed, sample_user: true
    group = create :group, sample_group: true
    group.members << users

    users.each.with_index do |user, index|
      UserGroupPoints.create!(group: group, user: user, amount: index + 1)
    end

    expectation = users.reverse

    assert_equal expectation.pluck(:name), group.top_members.pluck(:name)
    assert_equal 12, group.top_members(limit: 12).size
    assert_equal 6, group.top_members(limit: 6).size
  end
end
