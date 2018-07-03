# frozen_string_literal: true

require 'test_helper'

class Users::MembershipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:phil)

    sign_in(user)

    get user_groups_url(user)
    assert_response :success
  end
end
