# frozen_string_literal: true

require 'test_helper'

class UsersGroupsTest < ActionDispatch::IntegrationTest
  def setup
    @group   = groups(:one)
    @phil    = users(:phil)
    @woodell = users(:woodell)
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
    @group.add_to_organizers @woodell

    log_in_as @woodell

    visit user_groups_path @woodell

    assert page.has_content? "Nike [Organizer]"
  end

  test "user that is not group owner can't see 'edit group'" do
    log_in_as @woodell

    visit user_groups_path @woodell

    refute_edit_group_link
  end

  test "user that is not group owner can't see 'edit roles'" do
    log_in_as @woodell

    visit user_groups_path @woodell

    refute_edit_roles_link
  end

  test "group owner clicks on 'edit group'" do
    log_in_as @phil

    visit user_groups_path @phil

    click_on_edit_group

    assert_equal edit_group_path(@group), current_path
  end

  test "group owner clicks on 'edit roles'" do
    log_in_as @phil

    visit user_groups_path @phil

    click_on_edit_roles

    assert_equal group_roles_path(@group), current_path
  end

  private

    def refute_edit_group_link
      within "#group-#{@group.id}" do
        refute page.has_link? "Edit group"
      end
    end

    def refute_edit_roles_link
      within "#group-#{@group.id}" do
        refute page.has_link? "Edit roles"
      end
    end

    def click_on_edit_group
      within "#group-#{@group.id}" do
        click_on "Edit group"
      end
    end

    def click_on_edit_roles
      within "#group-#{@group.id}" do
        click_on "Edit roles"
      end
    end
end
