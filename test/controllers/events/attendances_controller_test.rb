# frozen_string_literal: true

require 'test_helper'

class Events::AttendancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attendance = attendances(:attendance_1)
    @event = @attendance.attended_event
    @group = @event.group
    @user  = @attendance.attendee
    @user.add_role :member, @group
  end

  test "should create attendance" do
    sign_in(@user)

    assert_difference('Attendance.count') do
      post event_attendances_url(@event), params: attendance_params
    end
  end

  test "should destroy attendance" do
    sign_in(@user)

    assert_difference('Attendance.count', -1) do
      delete event_attendance_url(@event, @attendance, format: :js)
    end
  end

  private

    def attendance_params
      { attendance:
        {
          attendee: @user,
          attended_event: events(:one)
        },
        format: :js
      }
    end
end
