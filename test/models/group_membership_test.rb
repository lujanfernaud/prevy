# frozen_string_literal: true

# == Schema Information
#
# Table name: group_memberships
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_group_memberships_on_group_id  (group_id)
#  index_group_memberships_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class GroupMembershipTest < ActiveSupport::TestCase
  def setup
    @user  = users(:carolyn)
    @group = groups(:kyoto)
  end

  test "adds and removes roles" do
    membership = GroupMembership.create!(user: @user, group: @group)

    assert @user.has_role? :member, @group

    membership.destroy!

    assert @user.roles.where(resource: @group).empty?
  end

  test "creates UserGroupPoints" do
    UserGroupPoints.expects(:create!).with(user: @user, group: @group)

    GroupMembership.create!(user: @user, group: @group)
  end

  test "destroys UserGroupPoints" do
    group_points = UserGroupPoints.new
    UserGroupPoints.expects(:find_by)
                   .with(user: @user, group: @group)
                   .returns(group_points)
    group_points.expects(:destroy)

    membership = GroupMembership.create!(user: @user, group: @group)
    membership.destroy
  end
end
