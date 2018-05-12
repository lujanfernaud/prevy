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
end
