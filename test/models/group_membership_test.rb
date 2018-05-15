require 'test_helper'

class GroupMembershipTest < ActiveSupport::TestCase
  test "adds and removes roles" do
    user  = users(:carolyn)
    group = groups(:kyoto)

    membership = GroupMembership.create(user: user, group: group)

    assert user.has_role? :member, group

    membership.destroy

    assert user.roles.where(resource: group).empty?
  end
end
