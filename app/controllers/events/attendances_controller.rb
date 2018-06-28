class Events::AttendancesController < ApplicationController
  include ApplicationHelper

  after_action :verify_authorized

  def create
    @event = find_event
    @attendance = new_attendance

    authorize @attendance

    if @attendance.save
      flash[:success] = "Yay! You are attending this event!"
    else
      flash[:danger] = "There has been an error. " \
        "Please refresh the page and try again."
    end

    redirect_to group_event_path(@event.group, @event)
  end

  def destroy
    @event = find_event
    @attendance = find_attendance

    authorize @attendance

    @attendance.destroy

    flash[:success] = "Your attendance to this event has been cancelled."

    redirect_to group_event_path(@event.group, @event)
  end

  private

    def find_event
      Event.find(params[:event_id])
    end

    def new_attendance
      Attendance.new(
        attended_event_id: @event.id,
        attendee_id: current_user.id
      )
    end

    def find_attendance
      Attendance.find_by(
        attended_event_id: @event.id,
        attendee_id: current_user.id
      )
    end
end
