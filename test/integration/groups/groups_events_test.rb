# frozen_string_literal: true

require 'test_helper'

class GroupsEventsTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users
  end

  test "user visits group events index" do
    user  = create :user, :confirmed
    group = create :group, owner: user

    create_list :event, 10, group: group, organizer: user

    log_in_as user

    visit group_events_path(group)

    within ".breadcrumb" do
      assert page.has_link?    group.name
      assert page.has_content? "Events"
    end

    assert page.has_content? "Events"
    assert page.has_css?     ".event-box"
  end
end
