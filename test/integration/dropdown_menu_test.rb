require 'test_helper'

class DropdownMenuTest < ActionDispatch::IntegrationTest
  test "new user" do
    user = users(:onitsuka)

    log_in_as(user)

    click_on user.name

    within ".dropdown-menu" do
      assert page.has_content? "Create event"
      assert page.has_content? "Create group"
      assert page.has_content? "Profile"
      assert page.has_content? "Account settings"
      assert page.has_content? "Log out"
    end
  end

  test "user has groups" do
    user = users(:phil)

    log_in_as(user)

    click_on user.name

    within ".dropdown-menu" do
      assert page.has_content? "My groups"

      click_on "My groups"

      assert current_path == user_groups_path(user)
    end
  end
end
