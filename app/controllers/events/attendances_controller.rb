# frozen_string_literal: true

class Events::AttendancesController < ApplicationController
  include ApplicationHelper

  before_action :find_event
  after_action  :verify_authorized

  def create
    @attendance = new_attendance

    authorize @attendance

    @attendance.save

    flash[:success] = "Yay! You are attending this event!"

    redirect_to group_event_path(@event.group, @event)
  end

  def destroy
    @attendance = find_attendance

    authorize @attendance

    @attendance.destroy

    flash[:success] = "Your attendance to this event has been cancelled."

    redirect_to group_event_path(@event.group, @event)
  end

  private

    def find_event
      @event = Event.find(params[:event_id])
    end

    def new_attendance
      Attendance.new(
        attended_event_id: @event.id,
        attendee_id:       current_user.id
      )
    end

    def find_attendance
      Attendance.find_by(
        attended_event_id: @event.id,
        attendee_id:       current_user.id
      )
    end
end
