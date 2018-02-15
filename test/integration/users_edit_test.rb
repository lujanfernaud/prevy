require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:phil)
  end

  test "update with valid name" do
    visit edit_user_path(@user)

    fill_in  "Name", with: "Philip"
    click_on "Update"

    assert_valid
  end

  test "update with valid email" do
    visit edit_user_path(@user)

    fill_in  "Email", with: "philip@sample.com"
    click_on "Update"

    assert_valid
  end

  test "update with valid password" do
    visit edit_user_path(@user)

    fill_in  "Password",              with: "more secure password"
    fill_in  "Password confirmation", with: "more secure password"
    click_on "Update"

    assert_valid
  end

  test "update with invalid name" do
    visit edit_user_path(@user)

    fill_in  "Name", with: "Ph"
    click_on "Update"

    assert_invalid
  end

  test "update with invalid email" do
    visit edit_user_path(@user)

    fill_in  "Email", with: "philip@sample"
    click_on "Update"

    assert_invalid
  end

  test "update with invalid password" do
    visit edit_user_path(@user)

    fill_in  "Password",              with: "pass"
    fill_in  "Password confirmation", with: "pass"
    click_on "Update"

    assert_invalid
  end

  test "update with empty location" do
    visit edit_user_path(@user)

    fill_in  "Location", with: ""
    click_on "Update"

    assert_invalid
  end

  test "update with invalid location" do
    visit edit_user_path(@user)

    fill_in  "Location", with: "A"
    click_on "Update"

    assert_invalid
  end

  private

    def assert_valid
      assert current_path, user_path(@user)
      assert page.has_content? "updated"
    end

    def assert_invalid
      assert current_path, edit_user_path(@user)
      assert page.has_content? "error"
    end
end
