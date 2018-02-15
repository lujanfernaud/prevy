require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "sign up with valid data" do
    visit signup_path

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"
    fill_in "Location",              with: "Tenerife"

    click_on "Sign up"
    assert page.has_content? "Welcome!"
  end

  test "sign up with invalid name" do
    visit signup_path

    fill_in "Name",                  with: "T"
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"
    fill_in "Location",              with: "Tenerife"

    click_on "Sign up"
    assert page.has_content? "error"
  end

  test "sign up with empty name" do
    visit signup_path

    fill_in "Name",                  with: ""
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"
    fill_in "Location",              with: "Tenerife"

    click_on "Sign up"
    assert page.has_content? "error"
  end

  test "sign up with invalid email" do
    visit signup_path

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: "test.test.com"
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"
    fill_in "Location",              with: "Tenerife"

    click_on "Sign up"
    assert page.has_content? "error"
  end

  test "sign up with empty email" do
    visit signup_path

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: ""
    fill_in "Password",              with: "password"
    fill_in "Password confirmation", with: "password"
    fill_in "Location",              with: "Tenerife"

    click_on "Sign up"
    assert page.has_content? "error"
  end

  test "sign up with invalid password" do
    visit signup_path

    fill_in "Name",                  with: "Test"
    fill_in "Email",                 with: "test@test.com"
    fill_in "Password",              with: "pass"
    fill_in "Password confirmation", with: "pass"
    fill_in "Location",              with: "Tenerife"

    click_on "Sign up"
    assert page.has_content? "error"
  end
end
