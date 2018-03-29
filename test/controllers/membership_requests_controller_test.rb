require 'test_helper'

class MembershipRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership_request = membership_requests(:one)
    @user  = @membership_request.user
    @group = @membership_request.group
    @owner = @group.owner

    ActionMailer::Base.deliveries.clear
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

    sign_in(woodell)

    assert_difference('MembershipRequest.count') do
      post group_membership_requests_url(group_two),
        params: membership_requests_params
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to group_path(group_two)
  end

  test "should destroy membership_request" do
    sign_in(@owner)

    assert_difference('MembershipRequest.count', -1) do
      delete group_membership_request_url(@group, @membership_request),
        headers: { "HTTP_REFERER" => "back" }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to user_membership_requests_url(@user)
  end

  private

    def membership_requests_params
      { membership_request:
        {
          message: "Hey, I'm Woodell!"
        }
      }
    end
end
