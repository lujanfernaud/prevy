# frozen_string_literal: true

require 'test_helper'

class EventsIndexTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users
  end

  test "logged in group member visits events index" do
    user  = create :user
    group = create :group
    group.members << user

    create_list :event, Event::EVENTS_PER_PAGE + 3, group: group

    log_in_as user

    visit group_events_path(group)

    assert page.has_css? ".pagination"
    assert_current_path group_events_path(group)
  end

  test "logged in user visits events index" do
    user  = create :user
    group = create :group

    log_in_as user

    visit group_events_path(group)

    assert_current_path root_path
  end

  test "logged out user visits events index" do
    group = create :group

    visit group_events_path(group)

    assert_current_path new_user_session_path
  end

  test "logged out invited user visits events index" do
    group = create :group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  "test@test.test"

    visit group_path(group, token: invitation.token)
    visit group_events_path(group)

    assert_current_path group_events_path(group)
  end

  test "logged in invited user visits events index" do
    user  = create :user
    group = create :group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  user.email

    log_in_as user

    visit group_path(group, token: invitation.token)
    visit group_events_path(group)

    assert_current_path group_events_path(group)
  end
end
