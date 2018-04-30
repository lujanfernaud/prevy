require 'test_helper'

class GroupsCreationTest < ActionDispatch::IntegrationTest
  def setup
    stub_geocoder
  end

  test "user with confirmed account creates a group" do
    prepare_javascript_driver

    user = users(:phil)

    log_in_as(user)
    visit root_path

    within ".navbar" do
      click_on user.name
    end

    within ".dropdown-menu" do
      click_on "Create group"
    end

    fill_in "Name",     with: "Test group"
    fill_in "Location", with: Faker::Address.city
    fill_in_description(Faker::Lorem.paragraph)
    attach_valid_image_for "group_image"

    choose "group_hidden_false"
    choose "group_all_members_can_create_events_false"

    within "form" do
      click_on "Create group"
    end

    assert page.has_content? "Yay! You created a group!"
  end

  test "user with unconfirmed account tries to create a group" do
    user = users(:unconfirmed)

    log_in_as(user)
    visit root_path

    within ".navbar" do
      click_on user.name
    end

    within ".dropdown-menu" do
      assert_create_group_link_disabled
      click_on "Create group"
    end

    refute page.has_current_path?(new_group_path)
  end
end
