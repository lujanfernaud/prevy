# frozen_string_literal: true

require 'test_helper'

class RecentAttendeesQueryTest < ActiveSupport::TestCase
  test "returns attendees by attendance creation date" do
    stub_sample_content_for_new_users

    jim   = create :user, :confirmed
    users = create_list :user, 3, :confirmed
    group = create :group
    group.members << users

    event = create :event
    event.attendees << [users[0], users[1], users[2]]
    event.attendees << jim

    result = RecentAttendeesQuery.call(event, 4)
    expected_result = [jim, users[2], users[1], users[0]]

    assert_equal expected_result, result
  end
end
