require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:phil)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post signup_url, params: user_params
    end

    assert_redirected_to login_url
  end

  test "should show user" do
    log_in_as users(:penny)

    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    log_in_as @user

    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    log_in_as @user

    patch user_url(@user), params: user_params
    assert_redirected_to user_url(@user)
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end

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
