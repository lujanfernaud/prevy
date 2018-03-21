require 'test_helper'

class GroupsBreadcrumbsTest < ActionDispatch::IntegrationTest
  def setup
    @group    = groups(:one)
    @event    = @group.events.first
    @phil     = users(:phil)
    @penny    = users(:penny)
    @woodell  = users(:woodell)
    @stranger = users(:stranger)

    add_group_owner_to_organizers
    add_to_members @penny
  end

  test "user visits group organizer from group 'show' view" do
    log_in_as @phil

    visit group_path @group

    within ".organizers-preview" do
      click_on @phil.name
    end

    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_link? "Organizers & Members"
      assert page.has_content? @phil.name

      click_on @group.name
    end

    assert page.current_path == group_path(@group)

    within ".organizers-preview" do
      click_on @phil.name
    end

    within ".breadcrumb" do
      click_on "Organizers & Members"
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits group member from group 'show' view" do
    log_in_as @phil

    visit group_path @group

    within ".members-preview" do
      click_on @penny.name
    end

    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_link? "Organizers & Members"
      assert page.has_content? @penny.name

      click_on @group.name
    end

    assert page.current_path == group_path(@group)

    within ".members-preview" do
      click_on @penny.name
    end

    within ".breadcrumb" do
      click_on "Organizers & Members"
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits group organizer from group members 'index' view" do
    log_in_as @phil

    visit group_members_path @group

    within ".organizers" do
      click_on @phil.name
    end

    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_link? "Organizers & Members"
      assert page.has_content? @phil.name

      click_on "Organizers & Members"
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits group member from group members 'index' view" do
    log_in_as @phil

    visit group_members_path @group

    within ".members" do
      click_on @penny.name
    end

    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_link? "Organizers & Members"
      assert page.has_content? @penny.name

      click_on "Organizers & Members"
    end

    assert page.current_path == group_members_path(@group)
  end

  test "user visits event from group 'show' view" do
    log_in_as @phil

    click_on @event.title

    assert page.has_css? ".breadcrumb"

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

    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_link? @event.title
      assert page.has_content? "Organizer"
      assert page.has_content? @phil.name

      click_on @event.title
    end

    assert page.current_path == group_event_path(@group, @event)
  end

  test "user visits event attendee from event 'show' view" do
    @event.attendees << @woodell

    log_in_as @phil

    visit group_event_path @group, @event

    within ".attendees-preview" do
      click_on @woodell.name
    end

    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_link? @event.title
      assert page.has_content? "Attendees"
      assert page.has_content? @woodell.name

      click_on @group.name
    end

    assert page.current_path == group_path(@group)
  end

  test "user visits event attendee from event attendees 'index' view" do
    @event.attendees << @woodell

    log_in_as @phil

    visit event_attendances_path @event

    within ".attendees" do
      click_on @woodell.name
    end

    assert page.has_css? ".breadcrumb"

    within ".breadcrumb" do
      assert page.has_link? @group.name
      assert page.has_link? @event.title
      assert page.has_content? "Attendees"
      assert page.has_content? @woodell.name

      click_on @group.name
    end

    assert page.current_path == group_path(@group)
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
end
