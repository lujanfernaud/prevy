require 'test_helper'

class FooterTest < ActionDispatch::IntegrationTest
  test "footer is shown in home page" do
    visit root_path

    assert_footer
  end

  test "footer is not shown in sign up page" do
    visit new_user_registration_path

    refute_footer
  end

  test "footer is not shown in log in page" do
    visit new_user_session_path

    refute_footer
  end

  test "footer is not shown in password recovery page" do
    visit new_user_password_path

    refute_footer
  end

  test "footer is not shown in confirmation page" do
    visit new_user_confirmation_path

    refute_footer
  end

  private

    def assert_footer
      assert page.has_css? footer_css
    end

    def refute_footer
      refute page.has_css? footer_css
    end

    def footer_css
      "footer.footer"
    end
end
