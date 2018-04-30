require 'test_helper'

class UsersAccountConfirmationTest < ActionDispatch::IntegrationTest
  test "owner with unconfirmed email visits sample group" do
    group = groups(:sample_group)
    user  = users(:user_1)

    log_in_as(user)

    visit group_path(group)

    click_on_resend_confirmation_link

    assert_confirmation_page
  end

  test "member with unconfirmed email visits group" do
    group = groups(:sample_group)
    user  = users(:unconfirmed)
    group.members << user

    log_in_as(user)

    visit group_path(group)

    click_on_resend_confirmation_link

    assert_confirmation_page
  end

  test "unconfirmed user visits 'My groups'" do
    user = users(:unconfirmed)

    log_in_as(user)

    visit user_groups_path(user)

    click_on_resend_confirmation_link

    assert_confirmation_page
  end

  private

    def click_on_resend_confirmation_link
      click_on "click here to resend confirmation"
    end

    def assert_confirmation_page
      assert page.has_current_path?(new_user_confirmation_path)
      assert page.has_field? "Email"
      assert page.has_button? "Resend confirmation instructions"
    end
end
