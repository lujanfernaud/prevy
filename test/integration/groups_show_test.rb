require 'test_helper'

class GroupsShowTest < ActionDispatch::IntegrationTest
  def setup
    @phil     = users(:phil)
    @penny    = users(:penny)
    @woodell  = users(:woodell)
    @onitsuka = users(:onitsuka)
  end

  test "group owner visits group" do
    @group = groups(:one)
    add_group_owner_to_organizers
    add_to_members(@penny, @woodell)

    log_in_as(@phil)

    visit group_path(@group)

    assert_group_info_and_image
    assert_organizers
    assert_members_preview
    refute_membership

    assert_upcoming_events
    assert_members
  end

  test "group member visits group" do
    @group = groups(:one)
    add_group_owner_to_organizers
    add_to_members(@penny, @woodell)

    log_in_as(@penny)

    visit group_path(@group)

    assert_group_info_and_image
    assert_organizers
    assert_members_preview
    refute_membership

    assert_upcoming_events
    assert_members
  end

  test "logged in user visits private group" do
    user   = users(:stranger)
    @group = groups(:one)
    add_group_owner_to_organizers
    add_to_members(@penny)

    log_in_as(user)

    visit group_path(@group)

    assert_group_info_and_image
    assert_organizers
    assert_members_preview_title
    assert_membership "Request membership"

    refute_upcoming_events
    refute_members
  end

  test "logged in user visits public group" do
    @group = groups(:public)
    add_group_owner_to_organizers
    add_to_members(@penny)

    log_in_as(@phil)

    visit group_path(@group)

    assert_group_info_and_image
    assert_organizers
    assert_members_preview_title
    assert_membership "Join group"

    assert_upcoming_events
    refute_members
  end

  test "logged out user visits private group" do
    @group = groups(:one)
    add_group_owner_to_organizers
    add_to_members(@penny)

    visit group_path(@group)

    assert_group_info_and_image
    assert_organizers
    assert_members_preview_title
    assert_members_count(1)
    assert_membership "Log in to request membership"

    refute_upcoming_events
    refute_members
  end

  test "logged out user visits public group" do
    @group = groups(:public)
    add_group_owner_to_organizers
    add_to_members(@penny)

    visit group_path(@group)

    assert_group_info_and_image
    assert_organizers
    assert_members_preview_title
    assert_members_count(1)
    assert_membership "Log in to join group"

    assert_upcoming_events
    refute_members
  end

  private

    # We need to do this because Rolify doesn't seem to work very well with
    # fixtures for scoped roles.
    def add_group_owner_to_organizers
      @group.owner.add_role(:organizer, @group)
    end

    def add_to_members(*users)
      users.each { |user| user.add_role(:member, @group) }
    end

    def assert_group_info_and_image
      assert page.has_css?     ".group-image"
      assert page.has_content? @group.name
      assert page.has_content? @group.city
      assert page.has_content? @group.description
    end

    def assert_organizers
      assert page.has_content? "Organizer"
      assert page.has_link?     @group.owner.name
    end

    def assert_members_preview
      assert_members_preview_title
      assert_members_preview_shows_members
    end

    def assert_members_preview_title
      count = @group.members_with_role.count

      within ".members-preview" do
        if count > 1
          assert page.has_content? "Members (#{count})"
        elsif count > 0
          assert page.has_content? "Member"
        else
          ""
        end
      end
    end

    def assert_members_preview_shows_members
      within ".members-preview" do
        last_members_names = @group.members_with_role.last(5).map(&:name)
        last_members_names.each do |name|
          assert page.has_link? name
        end
      end
    end

    def assert_members_count(number)
      within ".members-preview" do
        assert page.has_content? number
      end
    end

    def assert_membership(button_text)
      assert page.has_css? ".group-membership"
      assert page.has_content? button_text
    end

    def refute_membership
      refute page.has_css? ".group-membership"
    end

    def assert_upcoming_events
      assert page.has_content? "Upcoming"
      assert page.has_css?     ".event-box"
    end

    def refute_upcoming_events
      refute page.has_content? "Upcoming"
      refute page.has_css?     ".event-box"
    end

    def assert_members
      within ".members-container" do
        assert page.has_content? "Members"
        last_members_names = @group.members.last(12).map(&:name)
        last_members_names.each do |name|
          assert page.has_link? name
        end
      end
    end

    def refute_members
      refute page.has_css? ".members-container"
    end
end
