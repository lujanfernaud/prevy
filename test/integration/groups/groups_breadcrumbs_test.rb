require 'test_helper'

class GroupsBreadcrumbsTest < ActionDispatch::IntegrationTest
  def setup
    @group = groups(:one)
    @event = @group.events.first
    @phil  = users(:phil)
    @penny = users(:penny)

    add_group_owner_to_organizers @group
    add_members_to_group @group, @penny
  end

  test "user visits group organizer from group 'show' view" do
    log_in_as @phil

    visit group_path @group

    within ".organizers-preview" do
      click_on @phil.name
    end

    assert_organizer_and_members_breadcrumbs_for @group, @phil

    within ".breadcrumb" do
      click_on @group.name
    end

    assert page.current_path == group_path(@group)

    within ".organizers-preview" do
      click_on @phil.name
    end

    within ".breadcrumb" do
      click_on members_parent_title
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits group member from group 'show' view" do
    log_in_as @phil

    visit group_path @group

    within ".members-preview" do
      click_on @penny.name
    end

    assert_organizer_and_members_breadcrumbs_for @group, @penny

    within ".breadcrumb" do
      click_on @group.name
    end

    assert page.current_path == group_path(@group)

    within ".members-preview" do
      click_on @penny.name
    end

    within ".breadcrumb" do
      click_on members_parent_title
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits group organizer from group members 'index' view" do
    log_in_as @phil

    visit group_members_path @group

    within ".organizers" do
      click_on @phil.name
    end

    assert_organizer_and_members_breadcrumbs_for @group, @phil

    within ".breadcrumb" do
      click_on members_parent_title
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits group member from group members 'index' view" do
    log_in_as @phil

    visit group_members_path @group

    within ".members" do
      click_on @penny.name
    end

    assert_organizer_and_members_breadcrumbs_for @group, @penny

    within ".breadcrumb" do
      click_on members_parent_title
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits event from group 'show' view" do
    log_in_as @phil

    visit group_path @group

    click_on @event.title

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_content? @event.title

      click_on @group.name
    end

    assert page.current_path == group_path(@group)
  end

  test "user visits event organizer from event 'show' view" do
    log_in_as @phil

    visit group_event_path @group, @event

    within ".organizers-preview" do
      click_on @phil.name
    end

    assert_event_breadcrumbs_for @group, @event do
      assert page.has_content? attendees_parent_title
      assert page.has_content? @phil.name
    end

    within ".breadcrumb" do
      click_on @event.title
    end

    assert page.current_path == group_event_path(@group, @event)
  end

  test "user visits event attendee from event 'show' view" do
    woodell = users(:woodell)
    @event.attendees << woodell

    log_in_as @phil

    visit group_event_path @group, @event

    within ".attendees-preview" do
      click_on woodell.name
    end

    assert_event_breadcrumbs_for @group, @event do
      assert page.has_content? attendees_parent_title
      assert page.has_content? woodell.name
    end

    within ".breadcrumb" do
      click_on @group.name
    end

    assert page.current_path == group_path(@group)
  end

  test "user visits event attendee from event attendees 'index' view" do
    woodell = users(:woodell)
    @event.attendees << woodell

    log_in_as @phil

    visit event_attendances_path @event

    within ".attendees" do
      click_on woodell.name
    end

    assert_event_breadcrumbs_for @group, @event do
      assert page.has_content? attendees_parent_title
      assert page.has_content? woodell.name
    end

    within ".breadcrumb" do
      click_on @group.name
    end

    assert page.current_path == group_path(@group)
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
