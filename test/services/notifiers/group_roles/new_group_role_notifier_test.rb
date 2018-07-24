# frozen_string_literal: true

require 'test_helper'

class NewGroupRoleNotifierTest < ActiveSupport::TestCase
  def setup
    @user  = users(:woodell)
    @group = groups(:one)
  end

  test "add organizer role to user" do
    @user.remove_role :organizer, @group

    NewGroupRoleNotifier.call(user: @user, group: @group, role: "organizer")

    assert @user.has_role? :organizer, @group
  end
end
