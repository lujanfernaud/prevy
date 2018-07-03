# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @phil  = users(:phil)
    @penny = users(:penny)
  end

  test "should show user" do
    sign_in(@penny)

    get user_url(@phil)

    assert_response :success
  end

  test "should get edit" do
    sign_in(@phil)

    get edit_user_url(@phil)

    assert_response :success
  end

  test "should update user" do
    sign_in(@phil)

    patch user_url(@phil), params: user_params

    user = User.find(@phil.id)

    assert_redirected_to user_url(user)
  end

  private

    def user_params
      { user:
        {
          name:                  "Test user",
          email:                 "testuser@test.test",
          password:              "password",
          password_confirmation: "password",
          location:              "Everywhere",
          bio:                   "Not much to say."
        }
      }
    end
end
