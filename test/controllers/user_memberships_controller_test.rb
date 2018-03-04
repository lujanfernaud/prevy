require 'test_helper'

class UserMembershipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:phil)

    log_in_as(user)

    get user_groups_url(user)
    assert_response :success
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end
end
