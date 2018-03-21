require 'test_helper'

class GroupsRolesTest < ActionDispatch::IntegrationTest
  def setup
    @phil  = users(:phil)
    @group = groups(:one)
    @woodell = users(:woodell)
  end

  test "group owner adds organizer" do
    log_in_as @phil
    @woodell.add_role(:member, @group)

    visit group_members_path @group

    assert_equal 0, @group.organizers.count

    within "#user-#{@woodell.id}" do
      click_on "Add to organizers"
    end

    assert_equal 1, @group.organizers.count

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
    @woodell.add_role :organizer, @group

    log_in_as @phil

    visit group_members_path @group

    assert_equal 1, @group.organizers.count

    within "#user-#{@woodell.id}" do
      click_on "Delete from organizers"
    end

    assert_equal 0, @group.organizers.count

    log_out_as @phil

    log_in_as @woodell

    click_on "Notifications"

    within "#notification-#{@woodell.notifications.last.id}" do
      click_on "Go to group"
    end

    assert page.current_path == group_path(@group)
    refute page.has_link? "Create event"
  end
end
