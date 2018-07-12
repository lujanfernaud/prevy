# frozen_string_literal: true

require 'test_helper'

class FooterTest < ActionDispatch::IntegrationTest
  test "footer is shown in home page" do
    visit root_path

    assert page.has_css? footer_css
  end

  test "footer is not shown in sign up page" do
    visit new_user_registration_path

    refute page.has_css? footer_css
  end

  test "footer is not shown in log in page" do
    visit new_user_session_path

    refute page.has_css? footer_css
  end

  test "footer is not shown in password recovery page" do
    visit new_user_password_path

    refute page.has_css? footer_css
  end

  test "footer is not shown in confirmation page" do
    visit new_user_confirmation_path

    refute page.has_css? footer_css
  end

  test "footer is not shown in notifications settings page" do
    user = users(:phil)

    log_in_as user

    visit user_notification_settings_path user

    refute page.has_css? footer_css
  end

  test "footer is not shown in profile settings page" do
    user = users(:phil)

    log_in_as user

    visit edit_user_path user

    refute page.has_css? footer_css
  end

  private

    def footer_css
      "footer.footer"
    end
end
