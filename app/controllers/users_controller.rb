class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :set_event_if_coming_from_event, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Account created. Welcome!"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    redirect_to root_url unless @user

    if @event
      add_breadcrumbs
    end

    @attended_events = @user.past_attended_events
    @upcoming_events = @user.upcoming_attended_events
    @last_organized_events = @user.last_organized_events
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your details have been updated."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email,
                                   :password, :password_confirmation,
                                   :location, :bio)
    end

    def set_event_if_coming_from_event
      @organized_event = params[:organized_event] || false
      @attending_event = params[:attending_event] || false

      if @organized_event || @attending_event
        @event = Event.find(@organized_event || @attending_event)
      end
    end

    def add_breadcrumbs
      if @organized_event
        add_breadcrumbs_for "Organizer"
      end

      if @attending_event
        add_breadcrumbs_for "Attendees", event_attendances_path(@event)
      end
    end

    def add_breadcrumbs_for(title, path = nil)
      add_breadcrumb "Events", events_path
      add_breadcrumb @event.title, event_path(@event)
      add_breadcrumb title, path
      add_breadcrumb @user.name
    end
end
