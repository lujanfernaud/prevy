require 'test_helper'

class GroupsShowTest < ActionDispatch::IntegrationTest
  def setup
    @phil     = users(:phil)
    @penny    = users(:penny)
    @onitsuka = users(:onitsuka)
  end

  test "group owner visits group" do
    @group = groups(:one)

    log_in_as(@phil)

    visit group_path(@group)

    assert_group_info_and_image
    assert_owner
    assert_members_preview_shows_members
    refute_membership

    assert_upcoming_events
    assert_members
  end

  test "group member visits group" do
    @group = groups(:one)

    log_in_as(@penny)

    visit group_path(@group)

    assert_group_info_and_image
    assert_owner
    assert_members_preview_shows_members
    refute_membership

    assert_upcoming_events
    assert_members
  end

  test "logged in user visits private group" do
    @group = groups(:one)

    log_in_as(@onitsuka)

    visit group_path(@group)

    assert_group_info_and_image
    assert_owner
    assert_members_preview_shows_count
    assert_membership "Request invite"

    refute_upcoming_events
    refute_members
  end

  test "logged in user visits public group" do
    @group = groups(:public)

    log_in_as(@phil)

    visit group_path(@group)

    assert_group_info_and_image
    assert_owner
    assert_members_preview_shows_count
    assert_membership "Join group"

    assert_upcoming_events
    refute_members
  end

  test "logged out user visits private group" do
    @group = groups(:one)

    visit group_path(@group)

    assert_group_info_and_image
    assert_owner
    assert_members_preview_shows_count
    assert_membership "Log in to request invite"

    refute_upcoming_events
    refute_members
  end

  test "logged out user visits public group" do
    @group = groups(:public)

    visit group_path(@group)

    assert_group_info_and_image
    assert_owner
    assert_members_preview_shows_count
    assert_membership "Log in to join group"

    assert_upcoming_events
    refute_members
  end

  private

    def assert_group_info_and_image
      assert page.has_css?     ".group-image"
      assert page.has_content? @group.name
      assert page.has_content? @group.description
    end

    def assert_owner
      assert page.has_content? "Owner"
      assert page.has_link?     @group.owner.name
    end

    def assert_members_preview_shows_members
      within ".members-preview" do
        assert page.has_content? "Members (#{@group.members.count})"
        last_members_names = @group.members.last(5).map(&:name)
        last_members_names.each do |name|
          assert page.has_link? name
        end
      end
    end

    def assert_members_preview_shows_count
      within ".members-preview" do
        assert page.has_content? "Members"
        assert page.has_content? @group.members.count
      end
    end

    def assert_membership(button_text)
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
