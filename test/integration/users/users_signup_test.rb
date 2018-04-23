require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup
    stub_geocoder
  end

  test "sign up with valid data" do
    visit root_path

    click_on "Sign up"

    fill_in_correct_name
    fill_in_correct_email
    fill_in_correct_password

    within "form" do
      click_on "Sign up"
    end

    assert page.has_content? "A message with a confirmation link " \
                             "has been sent to your email address."
  end

  test "sign up with invalid name" do
    visit root_path

    click_on "Sign up"

    fill_in "Name", with: "T"
    fill_in_correct_email
    fill_in_correct_password

    within "form" do
      click_on "Sign up"
    end

    assert_invalid_with_message "Name is too short"
  end

  test "sign up with empty name" do
    visit root_path

    click_on "Sign up"

    fill_in "Name", with: ""
    fill_in_correct_email
    fill_in_correct_password

    within "form" do
      click_on "Sign up"
    end

    assert_invalid_with_message "Name can't be blank"

  end

  test "sign up with invalid email" do
    visit root_path

    click_on "Sign up"

    fill_in_correct_name
    fill_in "Email", with: "test.test.com"
    fill_in_correct_password

    within "form" do
      click_on "Sign up"
    end

    assert_invalid_with_message "Email is invalid"
  end

  test "sign up with empty email" do
    visit root_path

    click_on "Sign up"

    fill_in_correct_name
    fill_in "Email", with: ""
    fill_in_correct_password

    within "form" do
      click_on "Sign up"
    end

    assert_invalid_with_message "Email can't be blank"
  end

  test "sign up with invalid password" do
    visit root_path

    click_on "Sign up"

    fill_in_correct_name
    fill_in_correct_email
    fill_in "Password",              with: "pass"
    fill_in "Password confirmation", with: "pass"

    within "form" do
      click_on "Sign up"
    end

    assert_invalid_with_message "Password is too short"

  end

  private

    def fill_in_correct_name
      fill_in "Name", with: "Test"
    end

    def fill_in_correct_email
      fill_in "Email", with: "test@test.com"
    end

    def fill_in_correct_password
      fill_in "Password",              with: "password"
      fill_in "Password confirmation", with: "password"
    end

    def assert_invalid_with_message(message)
      assert page.has_content? "error"
      assert page.has_content? message
    end
end
