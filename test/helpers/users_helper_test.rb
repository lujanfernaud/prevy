# frozen_string_literal: true

# TODO: Remove file

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test "should return 'Organized (last 3)'" do
    user = users(:phil)
    user_organized_events = user.organized_events

    assert_equal "Organized (last 3)",
      organized_events_header(user_organized_events)
  end

  test "should return 'Organized'" do
    user = users(:penny)
    user_organized_events = user.organized_events

    assert_equal "Organized",
      organized_events_header(user_organized_events)
  end
end
