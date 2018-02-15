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

  test "user can edit it's own profile" do
    user = users(:penny)

    refute_nil edit_profile_link(user)
  end

  test "user can not edit other people's profiles" do
    user = users(:phil)

    assert_nil edit_profile_link(user)
  end

  private

    def current_user
      users(:penny)
    end
end
