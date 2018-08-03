# frozen_string_literal: true

require 'test_helper'

class UsersAccountTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:phil)
  end

  test "active tab in account settings is 'Account' tab" do
    log_in_as(@user)

    click_user_button
    click_on "Account settings"

    within ".nav-item-account" do
      assert page.has_css? ".nav-link.active"
    end
  end

  test "update with valid email" do
    log_in_as(@user)

    visit edit_user_registration_path(@user)

    fill_in  "Email",            with: "philip@sample.com"
    fill_in  "Current password", with: "password"
    click_on "Update"

    assert_valid do
      assert page.has_content? "we need to verify your new email address"
    end
  end

  test "update with invalid email" do
    log_in_as(@user)

    visit edit_user_registration_path(@user)

    fill_in  "Email",            with: "philip@sample"
    fill_in  "Current password", with: "password"
    click_on "Update"

    assert_invalid do
      assert page.has_content? "Email is not valid"
    end
  end

  test "update with valid password" do
    log_in_as(@user)

    visit edit_user_registration_path(@user)

    fill_in  "Password",              with: "more secure password"
    fill_in  "Password confirmation", with: "more secure password"
    fill_in  "Current password",      with: "password"
    click_on "Update"

    assert_valid
  end

  test "update with invalid password" do
    log_in_as(@user)

    visit edit_user_registration_path(@user)

    fill_in  "Password",              with: "pass"
    fill_in  "Password confirmation", with: "pass"
    fill_in  "Current password",      with: "password"
    click_on "Update"

    assert_invalid do
      assert page.has_content? "Password is too short"
    end
  end

  private

    def assert_valid
      assert_current_path root_path
      assert page.has_content? "updated"
      yield if block_given?
    end

    def assert_invalid
      assert_current_path "/users"
      assert page.has_content? "error"
      yield if block_given?
    end
end
