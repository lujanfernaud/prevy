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

  test "#sample_group" do
    someones_sample_group = groups(:sample_group)
    user = new_user

    assert_equal user.sample_group, user.groups.first

    someones_sample_group.members << user

    refute_equal someones_sample_group, user.sample_group
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

    assert_equal 2, penny.owned_groups.count
    assert_equal 1, phil.owned_groups.count
  end

  test "#associated_groups" do
    penny = users(:penny)
    phil  = users(:phil)

    assert_equal [groups(:one), groups(:four)], penny.associated_groups
    assert_equal [groups(:two), groups(:three)], phil.associated_groups
  end

  test "#received_requests" do
    phil = users(:phil)

    assert_equal 2, phil.received_requests.count
  end

  test "#sent_requests" do
    onitsuka = users(:onitsuka)

    assert_equal 1, onitsuka.sent_requests.count
  end

  test "#notifications" do
    phil = users(:phil)

    assert_equal 4, phil.notifications.count
  end

  test "#past_attended_events" do
    user = users(:phil)
    past_attended_events = user.past_attended_events

    assert_equal 2, past_attended_events.count
  end

  test "#upcoming_attended_events" do
    user = users(:woodell)
    upcoming_attended_events = user.upcoming_attended_events

    assert_equal 3, upcoming_attended_events.count
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

  test "capitalizes bio before updating" do
    bio = "it is impossible to build one's own happiness on the unhappiness of others."
    bio_capitalized = "It is impossible to build one's own happiness on the unhappiness of others."

    new_user.bio = bio

    new_user.save

    assert_equal bio_capitalized, new_user.bio
  end

  test "doesn't return an error if there is no bio" do
    new_user.bio = nil

    new_user.save
  end
end
