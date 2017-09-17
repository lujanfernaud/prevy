class EventsController < ApplicationController
  include ApplicationHelper

  before_action :find_event, only: [:show, :edit, :update]

  def index
    @events = Event.upcoming.includes(:address)
                   .paginate(page: params[:page], per_page: 15)
  end

  def new
    @event = Event.new
    @event.build_address
  end

  def create
    @event = current_user.organized_events.build(event_params)

    if @event.save
      flash[:success] = "Event successfully created."
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def show
    @attendees = @event.attendees.recent
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      flash[:success] = "Event updated."
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  def destroy
    @event = current_user.organized_events.find_by(id: params[:id])
    redirect_to root_url unless @event

    @event.destroy
    flash[:success] = "Event deleted."
    redirect_to user_path(current_user)
  end

  private

    def find_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event)
            .permit(:title, :description, :website,
                    :start_date, :end_date, :image,
                      address_attributes: [:place_name, :street1, :street2,
                                           :city, :post_code, :country])
    end
end
