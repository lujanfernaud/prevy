require 'test_helper'

class MembershipRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership_request = membership_requests(:one)
    @user  = @membership_request.user
    @group = @membership_request.group
  end

  test "should get index" do
    get group_membership_requests_url(@group)
    assert_response :success
  end

  test "should get new" do
    get new_group_membership_request_url(@group)
    assert_response :success
  end

  test "should create membership_request" do
    woodell   = users(:woodell)
    group_two = groups(:two)

    log_in_as(woodell)

    assert_difference('MembershipRequest.count') do
      post group_membership_requests_url(group_two),
        params: membership_requests_params
    end

    assert_redirected_to group_path(group_two)
  end

  test "should destroy membership_request" do
    assert_difference('MembershipRequest.count', -1) do
      delete group_membership_request_url(@group, @membership_request),
        headers: { "HTTP_REFERER" => "back" }
    end

    assert_redirected_to user_membership_requests_url(@user)
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end

    def membership_requests_params
      { membership_request:
        {
          message: "Hey, I'm Woodell!"
        }
      }
    end
end
