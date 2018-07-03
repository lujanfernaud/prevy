# frozen_string_literal: true

require 'test_helper'

class GroupsBreadcrumbsTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users

    @member   = build :user, :confirmed, name: "Member"
    @attendee = build :user, :confirmed, name: "Attendee"

    @group = create :group
    @event = create :event, group: @group, organizer: @group.owner

    @group.members   << [@member, @attendee]
    @event.attendees << @attendee
  end

  test "member visits group member from group 'show' view" do
    log_in_as @member

    visit group_path @group

    within ".members-preview" do
      click_on @attendee.name
    end

    assert_organizer_and_members_breadcrumbs_for @group, @attendee

    within ".breadcrumb" do
      click_on @group.name
    end

    assert_current_path group_path(@group)

    within ".members-preview" do
      click_on @attendee.name
    end

    within ".breadcrumb" do
      click_on members_parent_title
    end

    assert_current_path group_members_path(@group)
  end

  test "member visits group organizer from group members 'index' view" do
    log_in_as @member

    visit group_members_path @group

    within ".organizers" do
      click_on @event.organizer.name
    end

    assert_organizer_and_members_breadcrumbs_for @group, @event.organizer

    within ".breadcrumb" do
      click_on members_parent_title
    end

    assert_current_path group_members_path(@group)
  end

  test "member visits group member from group members 'index' view" do
    log_in_as @member

    visit group_members_path @group

    within ".members" do
      click_on @attendee.name
    end

    assert_organizer_and_members_breadcrumbs_for @group, @attendee

    within ".breadcrumb" do
      click_on members_parent_title
    end

    assert_current_path group_members_path(@group)
  end

  test "member visits event from group 'show' view" do
    log_in_as @member

    visit group_path @group

    click_on @event.title

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_content? @event.title

      click_on @group.name
    end

    assert_current_path group_path(@group)
  end

  test "member visits event organizer from event 'show' view" do
    log_in_as @member

    visit group_event_path @group, @event

    within ".organizers-preview" do
      click_on @event.organizer.name
    end

    assert_event_breadcrumbs_for @group, @event do
      assert page.has_content? attendees_parent_title
      assert page.has_content? @event.organizer.name
    end

    within ".breadcrumb" do
      click_on @event.title
    end

    assert_current_path group_event_path(@group, @event)
  end

  test "member visits event attendee from event 'show' view" do
    log_in_as @member

    visit group_event_path @group, @event

    within ".attendees-preview" do
      click_on @attendee.name
    end

    assert_event_breadcrumbs_for @group, @event do
      assert page.has_content? attendees_parent_title
      assert page.has_content? @attendee.name
    end

    within ".breadcrumb" do
      click_on @group.name
    end

    assert_current_path group_path(@group)
  end

  test "member visits event attendee from event attendees 'index' view" do
    log_in_as @member

    visit event_attendees_path @event

    within ".attendees" do
      click_on @attendee.name
    end

    assert_current_path event_attendee_path(@event, @attendee)

    assert_event_breadcrumbs_for @group, @event do
      assert page.has_content? attendees_parent_title
      assert page.has_content? @attendee.name
    end

    within ".breadcrumb" do
      click_on @group.name
    end

    assert_current_path group_path(@group)
  end

  private

    def assert_organizer_and_members_breadcrumbs_for(group, user)
      within ".breadcrumb" do
        assert page.has_link? group.name
        assert page.has_link? members_parent_title
        assert page.has_content? user.name

        yield if block_given?
      end
    end

    def assert_event_breadcrumbs_for(group, event)
      within ".breadcrumb" do
        assert page.has_link? group.name
        assert page.has_link? event.title

        yield if block_given?
      end
    end

    def members_parent_title
      "Organizers & Members"
    end

    def attendees_parent_title
      "Attendees"
    end
end
