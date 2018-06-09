require 'test_helper'

class DeleteGroupRoleTest < ActiveSupport::TestCase
  def setup
    @user  = users(:woodell)
    @group = groups(:one)
  end

  test "delete organizer role from user" do
    @user.add_role :organizer, @group

    DeleteGroupRole.call(user: @user, group: @group, role: "organizer")

    refute @user.has_role? :organizer, @group
  end
end
