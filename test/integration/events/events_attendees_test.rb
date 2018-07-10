# frozen_string_literal: true

require 'test_helper'

class EventsAttendeesTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users

    @stranger = create :user, :confirmed, name: "Stranger"
    attendees = build_list :user, 10, :confirmed
    @attendee = attendees.first

    @event = create :event
    @group = @event.group

    @group.members   << [@stranger] + attendees
    @event.attendees << attendees
    @event.reload
  end

  test "member visits attendees index" do
    visit_event_attendees_logged_in_as_stranger

    assert_breadcrumbs(@group, @event)

    assert page.has_content? @event.title
    assert page.has_content? "Attendees (#{@event.attendees_count})"

    assert_attendees_links(@event)
  end

  test "logged out user visits attendees index" do
    visit event_attendees_path(@event)

    assert_current_path new_user_session_path
  end

  test "logged in user visits attendees index" do
    user = create :user

    log_in_as user

    visit event_attendees_path(@event)

    assert_current_path root_path
  end

  test "logged out invited user visits attendees index" do
    event = create :event
    group = event.group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  "test@test.test"

    visit group_path(group, token: invitation.token)
    visit event_attendees_path(event)

    assert_current_path event_attendees_path(event)
  end

  test "logged in invited user visits attendees index" do
    user  = create :user
    event = create :event
    group = event.group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  user.email

    log_in_as user

    visit group_path(group, token: invitation.token)
    visit event_attendees_path(event)

    assert_current_path event_attendees_path(event)
  end

  test "attendee card shows points number" do
    attendee_group_points = @attendee.group_points_amount(@group)

    visit_event_attendees_logged_in_as_stranger

    within "#user-#{@attendee.id}" do
      assert page.has_content? attendee_group_points
    end
  end

  test "non-member user visits attendees" do
    onitsuka = users(:onitsuka)

    log_in_as onitsuka

    visit event_attendees_path(@event)

    assert_equal current_path, root_path
  end

  test "user visit attendee" do
    visit_event_attendees_logged_in_as_stranger

    click_on @attendee.name

    assert_current_path event_attendee_path(@event, @attendee)

    within ".breadcrumb" do
      assert page.has_link? "Attendees"
      click_on "Attendees"
    end

    assert_current_path event_attendees_path(@event)
  end

  test "logged out invited user visits attendee" do
    attendee = create :user
    event    = create :event
    group    = event.group

    group.members   << attendee
    event.attendees << attendee

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  "test@test.test"

    visit group_path(group, token: invitation.token)
    visit event_attendee_path(event, attendee)

    assert_current_path event_attendee_path(event, attendee)
  end

  test "logged in invited user visits attendee" do
    attendee = create :user
    user     = create :user
    event    = create :event
    group    = event.group

    group.members   << attendee
    event.attendees << attendee

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  user.email

    log_in_as user

    visit group_path(group, token: invitation.token)
    visit event_attendee_path(event, attendee)

    assert_current_path event_attendee_path(event, attendee)
  end

  private

    def visit_event_attendees_logged_in_as_stranger
      log_in_as @stranger

      visit event_attendees_path(@event)
    end

    def assert_breadcrumbs(group, event)
      assert page.has_css?  ".breadcrumb"
      assert page.has_link? event.title

      within ".breadcrumb" do
        click_on event.title
        assert_current_path group_event_path(group, event)
      end

      click_on "See all attendees"
      assert_current_path event_attendees_path(event)
    end

    def assert_attendees_links(event)
      event.attendees.map(&:name).each do |name|
        assert page.has_link? name
      end
    end
end
