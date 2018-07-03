# frozen_string_literal: true

require 'test_helper'

class Users::MembershipRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership_request = membership_requests(:one)
    @user = @membership_request.user
  end

  test "should get index" do
    get user_membership_requests_url(@user)
    assert_response :success
  end

  test "should show user_membership_request" do
    get user_membership_request_url(@user, @membership_request)
    assert_response :success
  end
end
