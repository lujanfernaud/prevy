# frozen_string_literal: true

require 'test_helper'

class RecentMembersQueryTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "returns members by membership creation date" do
    group   = create :group
    members = create_list :user, 15, :confirmed

    members.each.with_index do |member, index|
      amount = index + 1

      create :group_membership,
              group:      group,
              user:       member,
              created_at: amount.days.ago
    end

    memberships = GroupMembership.by_creation_date(group)
    expected    = memberships.limit(Group::RECENT_MEMBERS).pluck(:user_id)

    assert_equal expected, group.recent_members.pluck(:id)
  end

  test "deals well with unconfirmed members" do
    group       = create :group
    unconfirmed = create_list :user, 3
    confirmed   = create_list :user, 12, :confirmed

    members = unconfirmed + confirmed

    members.each.with_index do |member, index|
      amount = index + 1

      create :group_membership,
              group:      group,
              user:       member,
              created_at: amount.days.ago
    end

    expected = confirmed[0..Group::RECENT_MEMBERS - 1].map(&:id)

    assert_equal expected, group.recent_members.pluck(:id)
  end
end
