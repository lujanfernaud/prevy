# frozen_string_literal: true

class TopMembersQuery
  def self.call(group, limit)
    new(group, limit).call
  end

  def initialize(group, limit)
    @group = group
    @limit = limit
  end

  def call
    @group.members_with_role.
     joins(:user_group_points).
     where("user_group_points.group_id = ?", @group).
     order("user_group_points.amount DESC").
     limit(@limit)
  end
end
