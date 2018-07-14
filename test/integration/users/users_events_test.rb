# frozen_string_literal: true

require 'test_helper'

class UsersEventsTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users
  end

  test "user with events visits events index" do
    user  = create :user, :confirmed
    group = create :group, owner: user

    create_list :event, 10, group: group, organizer: user

    log_in_as user

    visit user_events_path(user)

    assert page.has_content? "Events"
    assert page.has_css?     ".event-box", count: 10
  end

  test "user without events visits events index" do
    user = create :user, :confirmed

    create :group, owner: user

    log_in_as user

    visit user_events_path(user)

    assert page.has_content? "Events"
    assert_not page.has_css? ".event-box"
    assert page.has_content? "There are no upcoming events"
  end
end
