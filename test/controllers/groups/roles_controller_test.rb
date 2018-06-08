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
end
