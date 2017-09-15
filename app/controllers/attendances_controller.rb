class AttendancesController < ApplicationController
  include ApplicationHelper

  def index
    @event = Event.find(params[:event_id])
    @attendees = @event.attendees
  end

  def create
    @attendance = Attendance.new(attended_event_id: params[:event_id])
    @attendance.attendee_id = current_user.id
    @event = Event.find(params[:event_id])

    if @attendance.save
      flash[:success] = "Yay! You are attending this event!"
    else
      flash[:danger] = "There has been an error. " \
        "Please refresh the page and try again."
    end

    redirect_to event_path(@event)
  end

  def destroy
    Attendance.find_by(attended_event_id: params[:event_id],
                       attendee_id: current_user.id).destroy
    flash[:success] = "Your attendance to this event has been cancelled."

    @event = Event.find(params[:event_id])
    redirect_to event_path(@event)
  end
end
