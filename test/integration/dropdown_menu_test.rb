require 'test_helper'

class DropdownMenuTest < ActionDispatch::IntegrationTest
  test "confirmed user" do
    user = users(:onitsuka)

    log_in_as(user)

    click_on user.name

    within ".dropdown-menu" do
      assert_create_group_link_enabled
      assert page.has_content? "My groups"
      assert page.has_content? "Profile"
      assert page.has_content? "Account settings"
      assert page.has_content? "Log out"
    end
  end

  test "unconfirmed user" do
    user = users(:unconfirmed)

    log_in_as(user)

    click_on user.name

    within ".dropdown-menu" do
      assert_create_group_link_disabled
      assert page.has_content? "My groups"
      assert page.has_content? "Profile"
      assert page.has_content? "Account settings"
      assert page.has_content? "Log out"
    end
  end
end
