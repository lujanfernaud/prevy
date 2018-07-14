# frozen_string_literal: true

require 'test_helper'

class SampleEventCreatorTest < ActiveSupport::TestCase
  def setup
    stub_geocoder
    stub_sample_content_for_new_users

    users  = SampleUser.collection_for_sample_group
    @group = create :group, sample_group: true
    @group.members << users
  end

  test "creates event with sample attendees" do
    SampleEventCreator.call(@group)
    event     = Event.last
    prevy_bot = SampleUser.find_by(email: "prevybot@prevy.test")

    assert_equal event.organizer.email, prevy_bot.email
    assert_not   event.attendees_count.zero?
  end

  test "increases count for UserGroupPoints" do
    group_points = UserGroupPoints.new

    UserGroupPoints.expects(:find_or_create_by!)
                   .at_least_once.returns(group_points)

    group_points.expects(:increase)
                .with(by: Attendance::POINTS).at_least_once
    group_points.expects(:increase)
                .with(by: Topic::POINTS).at_least_once
    group_points.expects(:increase)
                .with(by: TopicComment::POINTS).at_least_once

    SampleEventCreator.call(@group)
  end

  test "updates attendees count" do
    SampleEventCreator.call(@group)

    event = Event.last

    assert_equal event.attendees.size, event.reload.attendees_count
  end

  test "creates events sample comments" do
    SampleEventCommentsCreator.expects(:call)

    SampleEventCreator.call(@group)
  end
end
