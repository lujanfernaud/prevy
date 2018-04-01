class EventsController < ApplicationController
  require "will_paginate/array"
  include ApplicationHelper

  before_action :find_event, only: [:show, :edit, :update]
  after_action  :verify_authorized, except: [:index]

  def index
    if params[:group_id]
      @group  = Group.find(params[:group_id])
      @events = EventDecorator.collection(@group.events)
                              .paginate(page: params[:page], per_page: 15)

      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Events", group_events_path(@group)
    end

    if signed_in?
      user    = User.find(current_user.id)
      @events = EventDecorator.collection(user.events_from_groups)
                              .paginate(page: params[:page], per_page: 15)
    end
  end

  def new
    @group = Group.find(params[:group_id])
    @event = @group.events.build
    @event.build_address
    authorize @event
  end

  def create
    @group = Group.find(params[:group_id])
    @event = @group.events.build(event_params)
    @event.organizer = current_user
    authorize @event

    if @event.save
      flash[:success] = "Event successfully created."
      redirect_to group_event_path(@group, @event)
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:group_id])

    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb @event.title

    @organizer = @event.organizer
    @attendees = @event.attendees.recent
  end

  def edit
    @group = Group.find(params[:group_id])

    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb @event.title, group_event_path(@group, @event)
    add_breadcrumb "Edit event"
  end

  def update
    @group = Group.find(params[:group_id])

    if @event.update_attributes(event_params)
      flash[:success] = "Event updated."
      redirect_to group_event_path(@group, @event)
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
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
      @event = EventDecorator.new(event)
    end

    def event_params
      params.require(:event)
            .permit(:title, :description, :website,
                    :start_date, :end_date, :image, :group_id,
                      address_attributes: [:place_name, :street1, :street2,
                                           :city, :post_code, :country])
    end
end
