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

  test "#membership_request_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.membership_request_emails = false

    assert phil.membership_request_emails?
    refute penny.membership_request_emails?
  end

  test "#group_membership_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.group_membership_emails = false

    assert phil.group_membership_emails?
    refute penny.group_membership_emails?
  end

  test "#group_role_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.group_role_emails = false

    assert phil.group_role_emails?
    refute penny.group_role_emails?
  end

  test "#group_event_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.group_event_emails = false

    assert phil.group_event_emails?
    refute penny.group_event_emails?
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
    assert_equal phil.associated_groups,  [groups(:two), groups(:three)]
  end

  test "#received_requests" do
    phil = users(:phil)

    assert_equal phil.received_requests.count, 2
  end

  test "#sent_requests" do
    onitsuka = users(:onitsuka)

    assert_equal onitsuka.sent_requests.count, 1
  end

  test "#notifications" do
    phil = users(:phil)

    assert_equal phil.notifications.count, 3
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

  test "titleizes name before saving" do
    new_user.name = "john stevenson"

    new_user.save

    assert_equal "John Stevenson", new_user.name
  end

  test "titleizes location before updating" do
    new_user.location = "tenerife"

    new_user.save

    assert_equal "Tenerife", new_user.location
  end

  test "doesn't return an error if there is no location" do
    new_user.location = nil

    new_user.save
  end
end
