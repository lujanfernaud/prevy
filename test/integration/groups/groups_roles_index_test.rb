require 'test_helper'

class GroupsRolesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @phil    = users(:phil)
    @woodell = users(:woodell)
    @penny   = users(:penny)
    @group   = groups(:one)
  end

  test "shows organizers and moderators" do
    @group.add_to_organizers @phil
    @group.add_to_moderators @woodell
    @penny.add_role :member, @group

    log_in_as @phil

    visit group_roles_path(@group)

    within ".roles-organizers-moderators-container" do
      assert page.has_link? @phil.name
      assert page.has_link? @woodell.name
      refute page.has_link? @penny.name
    end
  end

  test "shows members" do
    @group.add_to_organizers @phil
    @group.add_to_organizers @woodell
    @penny.add_role :member, @group

    log_in_as @phil

    visit group_roles_path(@group)

    within ".roles-members-container" do
      refute page.has_link? @phil.name
      refute page.has_link? @woodell.name
      assert page.has_link? @penny.name
    end
  end

  test "user name link works" do
    @group.add_to_organizers @woodell

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on @woodell.name
    end

    assert_equal user_path(@woodell), current_path
  end

  test "add organizer role" do
    @woodell.add_role :member, @group

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on "Add organizer role"
    end

    within ".roles-organizers-moderators-container" do
      assert page.has_link? @woodell.name
    end

    within ".roles-members-container" do
      refute page.has_link? @woodell.name
    end

    within "#roles-user-#{@woodell.id}" do
      assert page.has_content? "[Organizer]"
    end
  end

  test "remove organizer role" do
    @group.add_to_organizers @woodell

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on "Remove organizer role"
    end

    within ".roles-organizers-moderators-container" do
      refute page.has_link? @woodell.name
    end

    within ".roles-members-container" do
      assert page.has_link? @woodell.name
    end

    within "#roles-user-#{@woodell.id}" do
      refute page.has_content? "[Organizer]"
    end
  end

  test "add moderator role" do
    @woodell.add_role :member, @group

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on "Add moderator role"
    end

    within ".roles-organizers-moderators-container" do
      assert page.has_link? @woodell.name
    end

    within ".roles-members-container" do
      refute page.has_link? @woodell.name
    end

    within "#roles-user-#{@woodell.id}" do
      assert page.has_content? "[Moderator]"
    end
  end

  test "remove mdoerator role" do
    @group.add_to_moderators @woodell

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on "Remove moderator role"
    end

    within ".roles-organizers-moderators-container" do
      refute page.has_link? @woodell.name
    end

    within ".roles-members-container" do
      assert page.has_link? @woodell.name
    end

    within "#roles-user-#{@woodell.id}" do
      refute page.has_content? "[Moderator]"
    end
  end

  test "a member can have organizer and moderator role" do
    @woodell.add_role :member, @group

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on "Add moderator role"
      click_on "Add organizer role"
    end

    within ".roles-organizers-moderators-container" do
      assert page.has_link? @woodell.name
    end

    within ".roles-members-container" do
      refute page.has_link? @woodell.name
    end

    within "#roles-user-#{@woodell.id}" do
      assert page.has_content? "[Organizer] [Moderator]"
    end
  end
end
