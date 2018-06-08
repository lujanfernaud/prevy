require 'test_helper'

class Groups::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
  end

  test "should get index" do
    get group_roles_url(@group)

    assert_response :success
  end
end
