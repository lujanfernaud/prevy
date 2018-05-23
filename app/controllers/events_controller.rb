class EventsController < ApplicationController
  require "will_paginate/array"
  include ApplicationHelper

  after_action :verify_authorized, except: :index

  def index
    authorize :event

    @group  = find_group
    @events = events_decorators_for @group.events

    add_breadcrumbs_for_index
  end

  def new
    @group = find_group
    @event = @group.events.build
    @event.build_address

    authorize @event

    add_breadcrumbs_for_new
  end

  def create
    @group = find_group
    @event = @group.events.build event_params
    @event.organizer = current_user

    authorize @event

    if @event.save
      flash[:success] = "Event successfully created."
      send_new_event_email
      redirect_to group_event_path(@group, @event)
    else
      render :new
    end
  end

  def show
    @group = find_group
    @event = find_event

    authorize @event

    add_breadcrumbs_for_show
  end

  def edit
    @group = find_group
    @event = find_event

    add_breadcrumbs_for_edit
  end

  def update
    @group = find_group
    @event = find_event

    authorize @event

    if @event.update_attributes event_params
      flash[:success] = "Event updated."
      send_updated_event_email
      redirect_to group_event_path(@group, @event)
    else
      render :edit
    end
  end

  def destroy
    @group = find_group
    @event = current_user.organized_events.find_by(id: params[:id])

    authorize @event

    redirect_to root_url unless @event

    @event.destroy
    flash[:success] = "Event deleted."
    redirect_to group_path(@group)
  end

  private

    def find_event
      event = Event.find(params[:id])
      authorize event
      EventDecorator.new(event)
    end

    def find_group
      Group.find(params[:group_id])
    end

    def events_decorators_for(concern)
      EventDecorator.collection(concern)
                    .paginate(page: params[:page], per_page: 15)
    end

    def add_breadcrumbs_for_index
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Events", group_events_path(@group)
    end

    def add_breadcrumbs_for_new
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Create event"
    end

    def add_breadcrumbs_for_show
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title
    end

    def add_breadcrumbs_for_edit
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb "Edit event"
    end

    def send_new_event_email
      NewEventEmail.call(@event)
    end

    def send_updated_event_email
      UpdatedEventEmail.call(@event)
    end

    def event_params
      params.require(:event)
            .permit(:title, :description, :website,
                    :start_date, :end_date, :image, :image_cache, :group_id,
                      address_attributes: [:place_name, :street1, :street2,
                                           :city, :state,
                                           :post_code, :country])
    end
end
