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
