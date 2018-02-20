require 'test_helper'

class GroupsCreationTest < ActionDispatch::IntegrationTest
  test "user creates a group" do
    Capybara.current_driver = :webkit
    Capybara.raise_server_errors = false

    user = users(:phil)

    log_in_as(user)
    visit root_path

    within ".navbar" do
      click_on user.name
    end

    within ".dropdown-menu" do
      click_on "Create group"
    end

    fill_in "Name", with: "Test group"
    fill_in_description(Faker::Lorem.paragraph)

    attach_valid_image

    choose "group_private_false"
    choose "group_hidden_false"
    choose "group_all_members_can_create_events_false"

    within "form" do
      click_on "Create group"
    end

    assert page.has_content? "Yay! You created a group!"

    within ".navbar" do
      click_on user.name
    end
  end

  private

    def fill_in_description(description)
      find("trix-editor").click.set(description)
    end

    def attach_valid_image
      attach_file "group_image", "test/fixtures/files/sample.jpeg"
    end
end
