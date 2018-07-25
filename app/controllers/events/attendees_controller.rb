# frozen_string_literal: true

class Events::AttendeesController < ApplicationController
  include Groups::AuthorizationRedirecter

  before_action :find_event
  before_action :find_group

  def index
    @attendees = @event.attendees.order(name: :desc)

    add_breadcrumbs_for_index
  end

  def show
    @user = find_user

    add_breadcrumbs_for_show

    render "users/show"
  end

  private

    def find_event
      @event ||= EventDecorator.new(Event.find(params[:event_id]))
    end

    def find_group
      @group ||= @event.group
    end

    def find_user
      User.find(params[:id])
    end

    def add_breadcrumbs_for_index
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb "Attendees", event_attendees_path(@event)
    end

    def add_breadcrumbs_for_show
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb "Attendees", event_attendees_path(@event)
      add_breadcrumb @user.name
    end
end
