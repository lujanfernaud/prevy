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

  test "creates UserGroupCommentsCount" do
    UserGroupCommentsCount.expects(:create!).with(user: @user, group: @group)

    GroupMembership.create!(user: @user, group: @group)
  end

  test "destroys UserGroupCommentsCount" do
    comments_count = UserGroupCommentsCount.new
    UserGroupCommentsCount.expects(:find_by)
                          .with(user: @user, group: @group)
                          .returns(comments_count)
    comments_count.expects(:destroy)

    membership = GroupMembership.create!(user: @user, group: @group)
    membership.destroy
  end
end
