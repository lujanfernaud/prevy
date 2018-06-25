require 'test_helper'

class Groups::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @phil  = users(:phil)
    @penny = users(:penny)
  end

  test "should show user" do
    sign_in(@penny)

    get group_member_url(@group, @phil)

    assert_response :success
  end
end
