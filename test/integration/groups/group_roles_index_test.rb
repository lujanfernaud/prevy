require 'test_helper'

class GroupsRolesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @phil    = users(:phil)
    @woodell = users(:woodell)
    @penny   = users(:penny)
    @group   = groups(:one)
  end

  test "shows organizers" do
    @group.add_to_organizers @phil
    @group.add_to_organizers @woodell
    @penny.add_role :member, @group

    log_in_as @phil

    visit group_roles_path(@group)

    within ".roles-organizers-container" do
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

  test "organizer has '[Organizer]' tag" do
    @group.add_to_organizers @woodell

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      assert page.has_content? "[Organizer]"
    end
  end

  test "organizer 'remove role' link works" do
    @group.add_to_organizers @woodell

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on "Remove organizer role"
    end

    within ".roles-organizers-container" do
      refute page.has_link? @woodell.name
    end

    within ".roles-members-container" do
      assert page.has_link? @woodell.name
    end

    within "#roles-user-#{@woodell.id}" do
      refute page.has_content? "[Organizer]"
    end
  end

  test "member 'add organizer role' link works" do
    @woodell.add_role :member, @group

    log_in_as @phil

    visit group_roles_path(@group)

    within "#roles-user-#{@woodell.id}" do
      click_on "Add organizer role"
    end

    within ".roles-organizers-container" do
      assert page.has_link? @woodell.name
    end

    within ".roles-members-container" do
      refute page.has_link? @woodell.name
    end

    within "#roles-user-#{@woodell.id}" do
      assert page.has_content? "[Organizer]"
    end
  end
end
