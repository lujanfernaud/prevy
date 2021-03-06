# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:phil)
    @group = groups(:strangers_group)

    stub_sample_content_for_new_users
  end

  test "login with valid data" do
    visit new_user_session_path

    fill_in "Email",    with: @user.email
    fill_in "Password", with: "password"

    within "form" do
      click_on "Log in"
    end

    assert_current_path root_path

    within ".navbar-nav" do
      assert page.has_content? @user.name
    end
  end

  test "login with invalid email" do
    visit new_user_session_path

    fill_in "Email",    with: "bademail@sample.com"
    fill_in "Password", with: "password"

    within "form" do
      click_on "Log in"
    end

    assert_current_path new_user_session_path
    assert page.has_content? "Invalid"
  end

  test "login with invalid password" do
    visit new_user_session_path

    fill_in "Email",    with: @user.email
    fill_in "Password", with: "pssswrrd"

    within "form" do
      click_on "Log in"
    end

    assert_current_path new_user_session_path
    assert page.has_content? "Invalid"
  end

  test "try to visit login path while being logged in" do
    log_in_as(@user)
    visit new_user_session_path

    assert_current_path root_path
    assert page.has_content? "You are already signed in."
  end

  test "user is redirected to the previous location after logging in" do
    group = create :group

    visit group_path(group)

    click_on "Log in"

    introduce_log_in_information_as(@user)

    assert_current_path group_path(group)
  end

  test "user is redirected to new membership request after logging in" do
    group = create :group

    visit group_path(group)

    click_on "Request membership"
    click_on "Log in"

    introduce_log_in_information_as(@user)

    assert_current_path new_group_membership_request_path(group)
  end

  test "logout" do
    log_in_as(@user)

    click_user_button
    click_on "Log out"

    assert_current_path root_path

    within ".navbar-nav" do
      assert page.has_content? "Log in"
    end
  end
end
