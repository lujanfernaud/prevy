class Events::AttendancesController < ApplicationController
  include ApplicationHelper

  after_action :verify_authorized, except: :index

  def index
    authorize :attendance

    @event = find_event
    @group = @event.group
    @attendees = @event.attendees

    add_breadcrumbs
  end

  def create
    @attendance = Attendance.new(attended_event_id: params[:event_id])
    @attendance.attendee_id = current_user.id
    @event = find_event

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
    @attendance = find_attendance
    @event = find_event

    authorize @attendance

    @attendance.destroy

    flash[:success] = "Your attendance to this event has been cancelled."

    redirect_to group_event_path(@event.group, @event)
  end

  private

    def find_attendance
      Attendance.find_by(attended_event_id: params[:event_id],
                         attendee_id: current_user.id)
    end

    def find_event
      Event.find(params[:event_id])
    end

    def add_breadcrumbs
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb "Attendees", event_attendances_path
    end
end
