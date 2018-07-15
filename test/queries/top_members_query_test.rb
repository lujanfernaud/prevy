# frozen_string_literal: true

require 'test_helper'

class TopMembersQueryTest < ActiveSupport::TestCase
  test "#top_members" do
    group = groups(:one)
    add_member_role(group: group, users: top_members_sorted.shuffle)

    expectation = top_members_sorted[0..11]

    assert_equal expectation, group.top_members
    assert_equal 12, group.top_members(limit: 12).size
    assert_equal 6, group.top_members(limit: 6).size
  end

  private

    def top_members_sorted
      woodell  = users(:woodell)
      carolyn  = users(:carolyn)
      stranger = users(:stranger)
      user_0   = users(:user_0)
      user_1   = users(:user_1)
      user_1   = users(:user_1)
      user_2   = users(:user_2)
      user_3   = users(:user_3)
      user_4   = users(:user_4)
      user_5   = users(:user_5)
      user_6   = users(:user_6)
      user_7   = users(:user_7)
      user_8   = users(:user_8)
      user_9   = users(:user_9)
      user_10  = users(:user_10)

      [woodell, carolyn, stranger, user_0, user_1, user_2,
        user_3, user_4, user_5, user_6, user_7, user_8, user_9, user_10]
    end

    def add_member_role(group:, users:)
      users.each { |u| u.add_role :member, group }
    end
end
