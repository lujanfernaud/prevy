# frozen_string_literal: true

require 'test_helper'

class RandomAttendeesQueryTest < ActiveSupport::TestCase
  test "returns random attendees" do
    stub_sample_content_for_new_users

    users = create_list :user, 15, :confirmed
    event = create :event
    event.attendees << users

    event.stubs(:attendees_count).returns(15)

    result_one = event.random_attendees.map(&:name)
    result_two = event.random_attendees.map(&:name)

    assert_not_equal result_one, result_two
  end
end
