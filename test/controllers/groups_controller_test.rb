# frozen_string_literal: true

require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    stub_sample_content_for_new_users

    @user  = create :user, :confirmed
    @group = create :group, owner: @user
  end

  test "should get index" do
    get groups_url

    assert_response :success
  end

  test "should get new" do
    sign_in(@user)

    get new_group_url

    assert_response :success
  end

  test "should create group" do
    sign_in(@user)

    assert_difference("Group.count") do
      post groups_url, params: { group: group_params }
    end

    group = Group.find(Group.last.id)

    assert_redirected_to group_url(group)
  end

  test "should show group" do
    get group_url(@group)

    assert_response :success
  end

  test "should get edit" do
    sign_in(@user)

    get edit_group_url(@group)

    assert_response :success
  end

  test "should update group" do
    sign_in(@user)

    patch group_url(@group), params: { group: group_params }

    group = Group.find(@group.id)

    assert_redirected_to group_url(group)
  end

  test "should destroy group" do
    sign_in(@user)

    assert_difference("Group.count", -1) do
      delete group_url(@group, user_id: @user)
    end

    assert_redirected_to user_groups_url(@user)
  end

  private

    def group_params
      {
        name:        "Test group",
        description: Faker::Lorem.paragraph,
        location:    Faker::Address.city,
        image:       upload_valid_image,
        hidden:      true,
        all_members_can_create_events: true
      }
    end
end
