require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:phil)
  end

  test "login with valid data" do
    visit login_path

    fill_in "Email",    with: @user.email
    fill_in "Password", with: "password"

    within "form" do
      click_on "Log in"
    end

    assert current_path == user_path(@user)
    assert page.has_content? "logged in"
  end

  test "login with invalid email" do
    visit login_path

    fill_in "Email",    with: "bademail@sample.com"
    fill_in "Password", with: "password"

    within "form" do
      click_on "Log in"
    end

    assert current_path == login_path
    assert page.has_content? "Invalid"
  end

  test "login with invalid password" do
    visit login_path

    fill_in "Email",    with: @user.email
    fill_in "Password", with: "pssswrrd"

    within "form" do
      click_on "Log in"
    end

    assert current_path == login_path
    assert page.has_content? "Invalid"
  end

  test "try to visit login path while being logged in" do
    log_in_as(@user)
    visit login_path

    assert current_path == user_path(@user)
    assert page.has_content? "You are already logged in."
  end

  test "logout" do
    log_in_as(@user)

    click_on @user.name
    click_on "Log out"

    assert current_path == root_path
    assert page.has_content? "Log in"
  end
end
