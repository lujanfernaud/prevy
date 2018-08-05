# frozen_string_literal: true

class Events::AttendancesController < ApplicationController
  include ApplicationHelper

  before_action :find_event
  after_action  :verify_authorized

  def create
    @attendance = new_attendance

    authorize @attendance

    @attendance.save
    @event.reload

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @attendance = find_attendance

    authorize @attendance

    @attendance.destroy
    @event.reload

    respond_to do |format|
      format.js
    end
  end

  private

    def find_event
      @event = EventDecorator.new(Event.find(params[:event_id]))
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
