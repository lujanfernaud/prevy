require 'test_helper'

class GroupsRolesTest < ActionDispatch::IntegrationTest
  def setup
    @phil  = users(:phil)
    @group = groups(:one)
    @woodell = users(:woodell)
    @penny = users(:penny)
    @pennys_group = groups(:three)
  end

  test "group owner allows all members to create events" do
    add_members [@phil, @woodell], group: @pennys_group

    refute_user_can_create_events @phil,    group: @pennys_group
    refute_user_can_create_events @woodell, group: @pennys_group

    log_in_as @penny

    visit edit_group_path @pennys_group
    set_all_members_can_create_events_to true

    log_out_as @penny

    assert_user_can_create_events @phil,    group: @pennys_group
    assert_user_can_create_events @woodell, group: @pennys_group
  end

  test "group owner disallows all members to create events" do
    add_members [@phil, @woodell], group: @pennys_group

    log_in_as @penny

    visit edit_group_path @pennys_group
    set_all_members_can_create_events_to true

    log_out_as @penny

    assert_user_can_create_events @phil,    group: @pennys_group
    assert_user_can_create_events @woodell, group: @pennys_group

    log_in_as @penny

    visit edit_group_path @pennys_group
    set_all_members_can_create_events_to false

    log_out_as @penny

    refute_user_can_create_events @phil,    group: @pennys_group
    refute_user_can_create_events @woodell, group: @pennys_group
  end

  test "group owner adds organizer" do
    @phil.add_role :organizer, @group
    @woodell.add_role :member, @group

    log_in_as @phil

    visit group_members_path @group

    assert_equal 1, @group.organizers.count

    within "#user-#{@woodell.id}" do
      click_on "Add to organizers"
    end

    assert_equal 2, @group.organizers.count

    log_out_as @phil

    log_in_as @woodell

    click_on "Notifications"

    within "#notification-#{@woodell.notifications.last.id}" do
      click_on "Go to group"
    end

    assert page.current_path == group_path(@group)
    assert page.has_link? "Create event"
  end

  test "group owner deletes organizer" do
    @phil.add_role :organizer, @group
    @woodell.add_role :organizer, @group

    log_in_as @phil

    visit group_members_path @group

    assert_equal 2, @group.organizers.count

    within "#user-#{@woodell.id}" do
      click_on "Delete from organizers"
    end

    assert_equal 1, @group.organizers.count

    log_out_as @phil

    log_in_as @woodell

    click_on "Notifications"

    within "#notification-#{@woodell.notifications.last.id}" do
      click_on "Go to group"
    end

    assert page.current_path == group_path(@group)
    refute page.has_link? "Create event"
  end

  test "member with organizer role cancels membership to group" do
    @woodell.add_role :organizer, @group

    log_in_as @woodell

    click_on @woodell.name
    click_on "My groups"

    within "#group-#{@group.id}" do
      click_on "Cancel membership"
    end

    visit group_path(@group)

    refute page.has_link? "Create event"
  end

  private

    def assert_user_can_create_events(user, group:)
      log_in_as(user)
      visit group_path(group)
      assert page.has_link? "Create event"
      log_out_as(user)
    end

    def refute_user_can_create_events(user, group:)
      log_in_as(user)
      visit group_path(group)
      refute page.has_link? "Create event"
      log_out_as(user)
    end

    def set_all_members_can_create_events_to(option)
      attach_valid_image
      choose "group_all_members_can_create_events_#{option}"
      click_on "Update group"
      assert page.has_content? "The group has been updated."
    end

    def attach_valid_image
      attach_file "group_image", "test/fixtures/files/sample.jpeg"
    end

    def add_members(users, group:)
      [users].flatten.each { |user| user.add_role :member, group }
    end
end
