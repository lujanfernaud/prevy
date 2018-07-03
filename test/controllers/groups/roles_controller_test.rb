# frozen_string_literal: true

require 'test_helper'

class Groups::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @user  = @group.owner
  end

  test "should get index" do
    sign_in @user

    get group_roles_url(@group)

    assert_response :success
  end

  test "should create role" do
    @user.remove_role :organizer, @group

    sign_in @user

    post group_roles_url(@group, user_id: @user, role: "organizer")

    assert @user.has_role? :organizer, @group
    assert_redirected_to group_roles_url(@group)
  end

  test "should destroy role" do
    @user.add_role :organizer, @group

    sign_in @user

    delete group_role_url(@group, @user, role: "organizer")

    refute @user.has_role? :organizer, @group
    assert_redirected_to group_roles_url(@group)
  end
end
