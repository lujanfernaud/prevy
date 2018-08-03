# frozen_string_literal: true

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

    page.execute_script("$('#navbarCollapse').toggle('.show')")

    within ".navbar" do
      click_user_button
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

  test "user tries to create a group with wrong data" do
    prepare_javascript_driver

    user = users(:phil)

    log_in_as(user)

    visit new_group_path

    fill_in "Name",     with: "T"
    fill_in "Location", with: Faker::Address.city
    fill_in_description(Faker::Lorem.paragraph)
    attach_valid_image_for "group_image"

    choose "group_hidden_false"
    choose "group_all_members_can_create_events_false"

    within "form" do
      click_on "Create group"
    end

    assert page.has_content? "error"
  end

  test "user with unconfirmed account tries to create a group" do
    user = users(:unconfirmed)

    log_in_as(user)

    visit root_path

    within ".navbar" do
      click_user_button
      click_on "Create group"
    end

    assert_current_path create_group_unconfirmed_path
  end
end
