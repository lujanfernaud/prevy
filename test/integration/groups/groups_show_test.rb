# frozen_string_literal: true

require 'test_helper'

class GroupsShowTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

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
    assert_members_preview(@group)
    assert_copy_group_link

    refute_membership
    refute_other_unhidden_groups

    assert_upcoming_events
    assert_topics(@group)
    assert_top_members(@group)
  end

  test "group member visits group" do
    add_members_to_group(@group, @penny, @woodell)

    log_in_as(@penny)

    visit group_path(@group)

    assert_group_info_and_image(@group)
    assert_members_preview(@group)
    assert_copy_group_link

    refute_membership
    refute_other_unhidden_groups

    assert_upcoming_events
    assert_topics(@group)
    assert_top_members(@group)
  end

  test "logged in user visits group" do
    stranger = users(:stranger)
    add_members_to_group(@group, @penny)

    log_in_as(stranger)

    visit group_path(@group)

    assert_group_info_and_image(@group)
    assert_admin(@group)
    assert_members_preview_title(@group)
    refute_copy_group_link
    assert_membership_button "Request membership"
    refute_unconfirmed_account_alerts

    assert_other_unhidden_groups

    refute_upcoming_events
    refute_topics
    refute_members
  end

  test "logged out user visits group" do
    add_members_to_group(@group, @penny)

    visit group_path(@group)

    assert_group_info_and_image(@group)
    assert_admin(@group)
    assert_members_preview_title(@group)
    assert_members_count(1)
    refute_copy_group_link
    assert_membership_button "Request membership"
    refute_unconfirmed_account_alerts

    assert_other_unhidden_groups

    refute_upcoming_events
    refute_topics
    refute_members
  end

  test "logged in user visits sample group" do
    stranger = users(:stranger)
    group = groups(:sample_group)

    log_in_as(stranger)

    visit group_path(group)

    assert_current_path root_path
  end

  test "logged out user visits sample group" do
    group = groups(:sample_group)

    visit group_path(group)

    assert_current_path root_path
  end

  test "owner with unconfirmed email visits sample group" do
    group = groups(:sample_group)
    user  = users(:user_1)
    group.add_to_organizers(user)
    add_members_to_group(group, @penny, @woodell)

    log_in_as(user)

    visit group_path(group)

    assert_members_preview(group)
    assert_copy_group_link

    assert_upcoming_events
    assert_topics(group)
    assert_top_members(group)
  end

  test "member with unconfirmed email visits group" do
    user = users(:unconfirmed)
    @group.members << user

    log_in_as(user)

    visit group_path(@group)

    refute_create_group_unconfirmed_alert
    assert_show_group_unconfirmed_alert

    refute_upcoming_events
    refute_topics
    refute_members
  end

  test "events section is not shown if there are no events" do
    stranger = users(:stranger)
    group    = create :group
    group.members << stranger

    log_in_as(stranger)

    visit group_path(group)

    refute_upcoming_events
  end

  private

    def assert_group_info_and_image(group)
      assert page.has_css?     ".group-image"
      assert page.has_content? group.name
      assert page.has_content? group.location
      assert page.has_content? group.description
    end

    def assert_admin(group)
      assert page.has_content? "Admin"
      assert page.has_content? group.owner.name
    end

    def assert_members_preview(group)
      assert_members_preview_title(group)
      assert_members_preview_shows_members(group)
    end

    def assert_members_preview_title(group)
      count = group.members_with_role.count

      within ".members-preview" do
        assert page.has_content? "Members (#{count})"
      end
    end

    def assert_members_preview_shows_members(group)
      within ".members-preview" do
        recent_members_names(group).each do |name|
          assert page.has_link? name
        end
      end
    end

    def recent_members_names(group)
      group.members.last(Group::RECENT_MEMBERS_SHOWN).pluck(&:name)
    end

    def assert_members_count(number)
      within ".members-preview" do
        assert page.has_content? number
      end
    end

    def assert_copy_group_link
      assert page.has_button? "Copy group link"
    end

    def refute_copy_group_link
      refute page.has_button? "Copy group link"
    end

    def assert_membership_button(button_text)
      assert page.has_css?     ".group-membership"
      assert page.has_content? button_text
    end

    def refute_membership
      refute page.has_css? ".group-membership"
    end

    def assert_other_unhidden_groups
      within ".unhidden-groups-container" do
        assert page.has_content? "Other Unhidden Groups"
        assert page.has_css?     ".group-box", count: 3
      end
    end

    def refute_other_unhidden_groups
      refute page.has_css? ".unhidden-groups-container"
    end

    def assert_upcoming_events
      assert page.has_css? ".upcoming-events-container"
      assert page.has_css? ".event-box"
    end

    def refute_upcoming_events
      refute page.has_css? ".upcoming-events-container"
    end

    def assert_top_members(group)
      within ".members-container" do
        assert page.has_content? "Most Involved Members"
        top_members_names = group.top_members.pluck(:name)

        top_members_names.each do |name|
          assert page.has_link? name
        end
      end
    end

    def refute_members
      refute page.has_css? ".members-container"
    end
end
