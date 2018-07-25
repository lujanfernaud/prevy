# frozen_string_literal: true

class EventsController < ApplicationController
  require "will_paginate/array"

  include ApplicationHelper
  include Groups::AuthorizationRedirecter

  before_action :find_group
  after_action  :verify_authorized, except: [:index, :show]

  def index
    @events = events_decorators_for @group.events

    add_breadcrumbs_for_index
  end

  def show
    @event    = EventDecorator.new(find_event)
    @comments = @event.comments.order(:created_at).includes(:user, :edited_by)
    @comment  = TopicComment.new

    add_breadcrumbs_for_show
  end

  def new
    @event = @group.events.build
    @event.build_address

    authorize @event

    add_breadcrumbs_for_creation
  end

  def edit
    @event = find_event

    authorize @event

    add_breadcrumbs_for_edition
  end

  def create
    @event = @group.events.build(event_params)

    authorize @event

    add_breadcrumbs_for_creation

    if @event.save
      flash[:success] = "Event successfully created."
      send_new_event_email
      redirect_to group_event_path(@group, @event)
    else
      render :new
    end
  end

  def update
    @event = find_event

    authorize @event

    add_breadcrumbs_for_edition

    if @event.update_attributes event_params
      flash[:success] = "Event updated."
      send_updated_event_email
      redirect_to group_event_path(@group, @event)
    else
      render :edit
    end
  end

  def destroy
    @event = current_user.organized_events.find(params[:id])

    authorize @event

    @event.destroy

    flash[:success] = "Event deleted."
    redirect_to group_path(@group)
  end

  private

    def find_group
      @group ||= Group.find(params[:group_id])
    end

    def events_decorators_for(events_collection)
      EventDecorator.collection(events_collection).paginate(
        page:     params[:page],
        per_page: Event::EVENTS_PER_PAGE
      )
    end

    def find_event
      Event.find(params[:id])
    end

    def send_new_event_email
      NewEventNotifier.call(@event)
    end

    def send_updated_event_email
      UpdatedEventNotifier.call(@event)
    end

    def event_params
      params.
        require(:event).
        permit(:title,
               :description,
               :website,
               :start_date,
               :end_date,
               :image,
               :image_cache,
               :group_id,
                address_attributes: [
                  :place_name,
                  :street1,
                  :street2,
                  :city,
                  :state,
                  :post_code,
                  :country
               ]).
        merge(organizer: current_user)
    end

    def add_breadcrumbs_for_index
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Events", group_events_path(@group)
    end

    def add_breadcrumbs_for_show
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title
    end

    def add_breadcrumbs_for_creation
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Create event"
    end

    def add_breadcrumbs_for_edition
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb "Edit event"
    end
end
