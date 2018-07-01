# frozen_string_literal: true

class Attendance < ApplicationRecord
  POINTS = 5

  belongs_to :attendee,       class_name: "User"
  belongs_to :attended_event, class_name: "Event"

  before_create  -> { user_group_points.increase by: POINTS }
  before_destroy -> { user_group_points.decrease by: POINTS }

  private

    def user_group_points
      UserGroupPoints.find_or_create_by!(user: attendee, group: group)
    end

    def group
      attended_event.group
    end
end
