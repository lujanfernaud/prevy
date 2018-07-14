# frozen_string_literal: true

require 'test_helper'

class UsersAccountConfirmationTest < ActionDispatch::IntegrationTest
  test "user with unconfirmed email tries to create a group" do
    stub_sample_content_for_new_users

    user = create :user

    log_in_as(user)

    within ".navbar" do
      click_on user.name
      click_on "Create group"
    end

    assert page.has_content? "Create Group"
    assert page.has_content? "You need to activate your account"

    click_on_resend_confirmation_link

    assert_confirmation_page
  end

  test "member with unconfirmed email visits group" do
    group = groups(:woodells_group)
    user  = users(:unconfirmed)
    group.members << user

    log_in_as(user)

    visit group_path(group)

    assert page.has_button? "Membership requested", disabled: true

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
