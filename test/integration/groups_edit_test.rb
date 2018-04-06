require 'test_helper'

class GroupsEditTest < ActionDispatch::IntegrationTest
  test "user edits a group" do
    Capybara.current_driver = :webkit
    Capybara.raise_server_errors = false

    user  = users(:phil)
    group = groups(:one)

    log_in_as(user)
    visit edit_group_path(group)

    fill_in "Name",     with: "Test group"
    fill_in "Location", with: Faker::Address.city
    fill_in_description(Faker::Lorem.paragraph)

    attach_valid_image

    choose "group_hidden_true"
    choose "group_all_members_can_create_events_true"

    click_on "Update group"
    assert page.has_content? "The group has been updated."

    visit edit_group_path(group)

    assert page.has_checked_field? "group_hidden_true"
    assert page.has_checked_field? "group_all_members_can_create_events_true"
    assert page.has_content? "Danger zone"
    assert page.has_link?    "Delete group"

    click_on "Delete group"

    assert page.has_content? "The group was deleted."
  end

  private

    def fill_in_description(description)
      find("trix-editor").click.set(description)
    end

    def attach_valid_image
      attach_file "group_image", "test/fixtures/files/sample.jpeg"
    end
end
