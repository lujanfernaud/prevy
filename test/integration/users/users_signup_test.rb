require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    stub_geocoder
  end

  test "sign up with valid data" do
    visit root_path

    sign_up_with_correct_information

    assert_signed_up_but_unconfirmed_message
  end

  test "sign up with invalid name" do
    visit root_path

    click_on "Sign up"

    fill_in "Name", with: "T"
    fill_in_correct_email
    fill_in_correct_password

    click_on_sign_up_form_button

    assert_invalid_with_message "Name is too short"
  end

  test "sign up with empty name" do
    visit root_path

    click_on "Sign up"

    fill_in "Name", with: ""
    fill_in_correct_email
    fill_in_correct_password

    click_on_sign_up_form_button

    assert_invalid_with_message "Name can't be blank"

  end

  test "sign up with invalid email" do
    visit root_path

    click_on "Sign up"

    fill_in_correct_name
    fill_in "Email", with: "test.test.com"
    fill_in_correct_password

    click_on_sign_up_form_button

    assert_invalid_with_message "Email is invalid"
  end

  test "sign up with empty email" do
    visit root_path

    click_on "Sign up"

    fill_in_correct_name
    fill_in "Email", with: ""
    fill_in_correct_password

    click_on_sign_up_form_button

    assert_invalid_with_message "Email can't be blank"
  end

  test "sign up with invalid password" do
    visit root_path

    click_on "Sign up"

    fill_in_correct_name
    fill_in_correct_email
    fill_in "Password", with: "pass"

    click_on_sign_up_form_button

    assert_invalid_with_message "Password is too short"
  end

  test "user is redirected to the previous location after signing up" do
    user  = users(:phil)
    group = groups(:strangers_group)

    visit group_path(group)

    click_on "Sign up"

    fill_in_correct_information
    click_on_sign_up_form_button

    assert current_path == group_path(group)
    assert_signed_up_but_unconfirmed_message
  end

  test "user is redirected to new membership request after signing up" do
    user  = users(:phil)
    group = groups(:strangers_group)

    visit group_path(group)

    click_on "Request membership"

    fill_in_correct_information
    click_on_sign_up_form_button

    assert current_path == new_group_membership_request_path(group)
    assert_signed_up_but_unconfirmed_message
  end

  private

    def sign_up_with_correct_information
      click_on "Sign up"

      fill_in_correct_information
      click_on_sign_up_form_button
    end

    def fill_in_correct_information
      fill_in_correct_name
      fill_in_correct_email
      fill_in_correct_password
    end

    def fill_in_correct_name
      fill_in "Name", with: "Test"
    end

    def fill_in_correct_email
      fill_in "Email", with: "test@test.com"
    end

    def fill_in_correct_password
      fill_in "Password", with: "password"
    end

    def click_on_sign_up_form_button
      within "form" do
        click_on "Sign up"
      end
    end

    def assert_signed_up_but_unconfirmed_message
      assert page.has_content? I18n.t("devise.registrations.signed_up_but_unconfirmed")
    end

    def refute_signed_up_but_unconfirmed_message
      refute page.has_content? I18n.t("devise.registrations.signed_up_but_unconfirmed")
    end

    def assert_invalid_with_message(message)
      assert page.has_content? "error"
      assert page.has_content? message
    end
end
