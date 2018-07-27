# frozen_string_literal: true

require 'test_helper'

class UsersProfileUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @phil  = users(:phil)
    @penny = users(:penny)
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

    fill_in  "Name", with: "P"
    click_on "Update"

    assert_invalid_for(@phil) do
      assert page.has_content? "Name is too short"
    end
  end

  private

    def assert_valid_for(user)
      friendly_user = User.find(user.id)

      assert_current_path user_path(friendly_user)
      assert page.has_content? "updated"
    end

    def assert_invalid_for(user)
      friendly_user = User.find(user.id)

      assert_current_path user_path(friendly_user)
      assert page.has_content? "error"
      yield if block_given?
    end
end
