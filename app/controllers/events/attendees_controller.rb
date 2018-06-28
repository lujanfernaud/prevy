class Events::AttendeesController < ApplicationController
  before_action :redirect_to_sign_up, if: :not_logged_in?
  before_action :find_event
  before_action :redirect_to_root, unless: :authorized?

  # Event attendees
  def index
    @group = @event.group
    @attendees = @event.attendees.order(name: :desc)

    add_breadcrumbs_for_index
  end

  # Event attendee profile
  def show
    @user = find_user

    add_breadcrumbs_for_show

    render "users/show"
  end

  private

    def redirect_to_sign_up
      redirect_to new_user_registration_path
    end

    def not_logged_in?
      !current_user
    end

    def find_event
      @event = Event.find(params[:event_id])
    end

    def redirect_to_root
      redirect_to root_path
    end

    def authorized?
      @event.group.user_is_authorized? current_user
    end

    def find_user
      User.find(params[:id])
    end

    def member(group = @group)
      Member.new(current_user, group)
    end

    def add_breadcrumbs_for_index
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb "Attendees", event_attendees_path(@event)
    end

    def add_breadcrumbs_for_show
      @group = @event.group

      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb "Attendees", event_attendees_path(@event)
      add_breadcrumb @user.name
    end
end
