# frozen_string_literal: true

require 'test_helper'

class SampleEventTest < ActiveSupport::TestCase
  def setup
    stub_geocoder

    @group = groups(:one)

    add_members_with_role
  end

  test "creates event with sample attendees and sample comments" do
    SampleEvent.create_for_group(@group)
    event = Event.last
    prevy_bot = SampleUser.find_by(email: "prevybot@prevy.test")

    assert_equal event.organizer.email, prevy_bot.email
    assert_not   event.attendees_count.zero?

    assert event.comments.size > 5
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

    SampleEvent.create_for_group(@group)
  end

  test "touches users after adding comments" do
    previous_updated_at = @group.members.pluck(:updated_at)

    SampleEvent.create_for_group(@group)

    updated_at = @group.members.reload.pluck(:updated_at)

    assert_not_equal previous_updated_at, updated_at
  end

  private

    def add_members_with_role
      @group.members.each do |user|
        user.add_role :member, @group
      end
    end
end
