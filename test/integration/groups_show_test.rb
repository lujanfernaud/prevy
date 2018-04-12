require 'test_helper'

class GroupsShowTest < ActionDispatch::IntegrationTest
  def setup
    @phil     = users(:phil)
    @penny    = users(:penny)
    @woodell  = users(:woodell)
    @onitsuka = users(:onitsuka)
    @group    = groups(:one)

    add_group_owner_to_organizers(@group)
  end

  test "group owner visits group" do
    add_members_to_group(@group, @penny, @woodell)

    log_in_as(@phil)

    visit group_path(@group)

    assert_group_info_and_image(@group)
    assert_organizers(@group)
    assert_members_preview(@group)
    refute_membership

    assert_upcoming_events
    assert_members(@group)
  end

  test "group member visits group" do
    add_members_to_group(@group, @penny, @woodell)

    log_in_as(@penny)

    visit group_path(@group)

    assert_group_info_and_image(@group)
    assert_organizers(@group)
    assert_members_preview(@group)
    refute_membership

    assert_upcoming_events
    assert_members(@group)
  end

  test "logged in user visits group" do
    stranger = users(:stranger)
    add_members_to_group(@group, @penny)

    log_in_as(stranger)

    visit group_path(@group)

    assert_group_info_and_image(@group)
    assert_organizers(@group)
    assert_members_preview_title(@group)
    assert_membership_button "Request membership"

    refute_upcoming_events
    refute_members
  end

  test "logged out user visits group" do
    add_members_to_group(@group, @penny)

    visit group_path(@group)

    assert_group_info_and_image(@group)
    assert_organizers(@group)
    assert_members_preview_title(@group)
    assert_members_count(1)
    assert_membership_button "Log in to request membership"

    refute_upcoming_events
    refute_members
  end

  private

    def assert_group_info_and_image(group)
      assert page.has_css?     ".group-image"
      assert page.has_content? group.name
      assert page.has_content? group.location
      assert page.has_content? group.description
    end

    def assert_organizers(group)
      assert page.has_content? "Organizer"
      assert page.has_link?    group.owner.name
    end

    def assert_members_preview(group)
      assert_members_preview_title(group)
      assert_members_preview_shows_members(group)
    end

    def assert_members_preview_title(group)
      count = group.members_with_role.count

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

    def assert_members_preview_shows_members(group)
      within ".members-preview" do
        last_members_names = group.members_with_role.last(5).map(&:name)
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

    def assert_membership_button(button_text)
      assert page.has_css?     ".group-membership"
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

    def assert_members(group)
      within ".members-container" do
        assert page.has_content? "Members"
        last_members_names = group.members.last(12).map(&:name)
        last_members_names.each do |name|
          assert page.has_link? name
        end
      end
    end

    def refute_members
      refute page.has_css? ".members-container"
    end
end
