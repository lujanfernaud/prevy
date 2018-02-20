require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "is valid" do
    user = users(:phil)
    assert user.valid?
  end

  test "is invalid without name" do
    user = users(:phil)
    user.name = ""

    refute user.valid?
  end

  test "is invalid with short name" do
    user = users(:phil)
    user.name = "Ph"

    refute user.valid?
  end

  test "is invalid without email" do
    user = users(:phil)
    user.email = ""

    refute user.valid?
  end

  test "is invalid with bad email" do
    user = users(:phil)
    user.email = "phil.example.com"

    refute user.valid?

    user.email = "@example.com"

    refute user.valid?

    user.email = "phil@example"

    refute user.valid?
  end

  test "is invalid with short password" do
    user = users(:phil)
    user.password = "passw"

    refute user.valid?
  end

  test ".recent returns newest 5 users" do
    newest_users = [users(:penny),
                    users(:woodell),
                    users(:onitsuka),
                    users(:user_0),
                    users(:phil)]

    assert_equal User.recent, newest_users
  end

  test "#past_attended_events" do
    user = users(:phil)
    past_attended_events = user.past_attended_events

    assert past_attended_events.count, 3
  end

  test "#upcoming_attended_events" do
    user = users(:phil)
    upcoming_attended_events = user.upcoming_attended_events

    assert upcoming_attended_events.count, 3
  end

  test "#owned_groups" do
    penny = users(:penny)
    phil  = users(:phil)

    assert penny.owned_groups.count, 2
    assert phil.owned_groups.count,  1
  end

  test "#associated_groups" do
    penny = users(:penny)
    phil  = users(:phil)

    assert_equal penny.associated_groups, [groups(:one), groups(:four)]
    assert_equal phil.associated_groups,  [groups(:two)]
  end
end
