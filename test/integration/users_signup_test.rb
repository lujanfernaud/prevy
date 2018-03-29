require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "sign up with valid data" do
    visit root_path

    click_on "Sign up"

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"

    within "form" do
      click_on "Sign up"
    end

    assert page.has_content? "A message with a confirmation link has been sent to your email address."
  end

  test "sign up with invalid name" do
    visit root_path

    click_on "Sign up"

    fill_in "Name",                  with: "T"
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"

    within "form" do
      click_on "Sign up"
    end

    assert_invalid do
      assert page.has_content? "Name is too short"
    end
  end

  test "sign up with empty name" do
    visit root_path

    click_on "Sign up"

    fill_in "Name",                  with: ""
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"

    within "form" do
      click_on "Sign up"
    end

    assert_invalid do
      assert page.has_content? "Name can't be blank"
    end
  end

  test "sign up with invalid email" do
    visit root_path

    click_on "Sign up"

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: "test.test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"

    within "form" do
      click_on "Sign up"
    end

    assert_invalid do
      assert page.has_content? "Email is invalid"
    end
  end

  test "sign up with empty email" do
    visit root_path

    click_on "Sign up"

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: ""
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"

    within "form" do
      click_on "Sign up"
    end

    assert_invalid do
      assert page.has_content? "Email can't be blank"
    end
  end

  test "sign up with invalid password" do
    visit root_path

    click_on "Sign up"

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "pass"
    fill_in "Password confirmation", with: "pass"

    within "form" do
      click_on "Sign up"
    end

    assert_invalid do
      assert page.has_content? "Password is too short"
    end
  end

  private

    def assert_invalid
      assert page.has_content? "error"
      yield if block_given?
    end
end
