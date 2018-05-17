require 'test_helper'

class UsersGroupsTest < ActionDispatch::IntegrationTest
  test "confirmed user visits 'My groups'" do
    user = users(:phil)

    log_in_as user

    visit user_groups_path user

    refute_create_group_unconfirmed_alert
  end

  test "unconfirmed user visits 'My groups'" do
    user = users(:unconfirmed)

    log_in_as user

    visit user_groups_path user

    assert_create_group_unconfirmed_alert
    assert_create_group_unconfirmed_button
  end

  test "user is organizer in a not owned group" do
    woodell = users(:woodell)
    nike_group = groups(:one)
    nike_group.add_to_organizers woodell

    log_in_as woodell

    visit user_groups_path woodell

    assert page.has_content? "Nike [Organizer]"
  end
end
