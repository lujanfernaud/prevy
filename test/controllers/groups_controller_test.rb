require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @user  = users(:phil)
  end

  test "should get index" do
    get groups_url
    assert_response :success
  end

  test "should get new" do
    log_in_as(@user)

    get new_group_url
    assert_response :success
  end

  test "should create group" do
    log_in_as(@user)

    assert_difference("Group.count") do
      post groups_url, params: { group: group_params }
    end

    assert_redirected_to group_url(Group.last)
  end

  test "should show group" do
    get group_url(@group)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_url(@group)
    assert_response :success
  end

  test "should update group" do
    patch group_url(@group), params: { group: group_params }
    assert_redirected_to group_url(@group)
  end

  test "should destroy group" do
    assert_difference("Group.count", -1) do
      delete group_url(@group, user_id: @user)
    end

    assert_redirected_to user_groups_url(@user)
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end

    def upload_valid_image
      fixture_file_upload("test/fixtures/files/sample.jpeg", "image/jpeg")
    end

    def group_params
      {
        name:        "Test group",
        description: Faker::Lorem.paragraph,
        image:       upload_valid_image,
        private:     true,
        hidden:      true,
        all_members_can_create_events: true
      }
    end
end
