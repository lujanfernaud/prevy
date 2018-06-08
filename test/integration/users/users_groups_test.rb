require 'test_helper'

class UsersGroupsTest < ActionDispatch::IntegrationTest
  def setup
    @group = groups(:one)
    @phil  = users(:phil)
  end

  test "confirmed user visits 'My groups'" do
    log_in_as @phil

    visit user_groups_path @phil

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
    @group.add_to_organizers woodell

    log_in_as woodell

    visit user_groups_path woodell

    assert page.has_content? "Nike [Organizer]"
  end

  test "user clicks on 'edit group'" do
    log_in_as @phil

    visit user_groups_path @phil

    click_on_edit_group

    assert_equal edit_group_path(@group), current_path
  end

  test "user clicks on 'edit roles'" do
    log_in_as @phil

    visit user_groups_path @phil

    click_one_edit_roles

    assert_equal group_roles_path(@group), current_path
  end

  private

    def click_on_edit_group
      within "#group-#{@group.id}" do
        click_on "Edit group"
      end
    end

    def click_one_edit_roles
      within "#group-#{@group.id}" do
        click_on "Edit roles"
      end
    end
end
