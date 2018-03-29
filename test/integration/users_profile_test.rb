require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @phil     = users(:phil)
    @penny    = users(:penny)
    @onitsuka = users(:onitsuka)
  end

  test "user visits profile" do
    log_in_as(@penny)

    visit user_path(@phil)

    assert page.has_content? @phil.name
    assert page.has_css?     "img"
    assert page.has_content? "Location"
    assert page.has_content? @phil.location
    assert page.has_content? "Bio"
    assert page.has_content? @phil.bio
    assert page.has_content? "Organized"
    assert page.has_css?     ".box"
  end

  test "profile shows 'Organized'" do
    log_in_as(@penny)

    visit user_path(@phil)

    assert page.has_content? "Organized"
  end

  test "profile shows 'Organized (last 3)'" do
    log_in_as(@penny)

    visit user_path(@phil)

    assert page.has_content? "Organized (last 3)"
  end

  test "profile does not show 'Organized'" do
    log_in_as(@onitsuka)

    visit user_path(@onitsuka)

    assert_not page.has_content? "Organized"
  end

  test "profile shows edit link for logged in user" do
    log_in_as(@phil)

    visit user_path(@phil)

    assert page.has_content? "Edit profile"
  end

  test "profile does not show edit link for other users" do
    log_in_as(@phil)

    visit user_path(@penny)

    assert_not page.has_content? "Edit profile"
  end

  test "active tab in profile settings is 'Profile' tab" do
    log_in_as(@phil)

    visit edit_user_path(@phil)

    within ".nav-item-profile" do
      assert page.has_css? ".nav-link.active"
    end
  end

  test "update profile with valid name" do
    log_in_as(@phil)

    visit edit_user_path(@phil)

    fill_in  "Name", with: "Philip"
    click_on "Update"

    assert_valid_for(@phil)
  end

  test "update profile with invalid name" do
    log_in_as(@phil)

    visit edit_user_path(@phil)

    fill_in  "Name", with: "Ph"
    click_on "Update"

    assert_invalid_for(@phil) do
      assert page.has_content? "Name is too short"
    end
  end

  private

    def assert_valid_for(user)
      assert current_path == user_path(user)
      assert page.has_content? "updated"
    end

    def assert_invalid_for(user)
      assert current_path == user_path(user)
      assert page.has_content? "error"
      yield if block_given?
    end
end
