require 'test_helper'

class UserMembershipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:phil)

    sign_in(user)

    get user_groups_url(user)
    assert_response :success
  end
end
