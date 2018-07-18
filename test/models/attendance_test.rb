# frozen_string_literal: true

# == Schema Information
#
# Table name: attendances
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  attended_event_id :bigint(8)
#  attendee_id       :bigint(8)
#
# Indexes
#
#  index_attendances_on_attended_event_id  (attended_event_id)
#  index_attendances_on_attendee_id        (attendee_id)
#

require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "touches user when attending an event" do
    user  = create :user
    group = create :group
    group.members << user

    event = create :event, group: group

    user.update_attributes(updated_at: 1.day.ago)

    assert_in_delta 1.day.ago, user.updated_at, 5.minutes

    event.attendees << user

    assert_in_delta event.reload.updated_at, user.reload.updated_at, 5.minutes
  end

  test "increases count for UserGroupPoints" do
    attendance = build :attendance

    points_amount = UserGroupPoints.new
    UserGroupPoints.expects(:find_or_create_by!).returns(points_amount)
    points_amount.expects(:increase).with(by: Attendance::POINTS)

    attendance.save!
  end

  test "decreases count for UserGroupPoints" do
    attendance = create :attendance

    group_points = UserGroupPoints.new
    UserGroupPoints.expects(:find_or_create_by!).returns(group_points)
    group_points.expects(:decrease).with(by: Attendance::POINTS)

    attendance.destroy!
  end
end
