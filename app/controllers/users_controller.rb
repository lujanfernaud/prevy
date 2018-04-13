class UsersController < ApplicationController
  before_action :set_event_if_coming_from_event, only: :show
  before_action :set_group_if_coming_from_group, only: :show
  after_action  :verify_authorized

  # User profile
  def show
    @user = find_user
    store_events

    authorize @user

    if coming_from_group_or_event
      add_breadcrumbs
    end
  end

  # Profile settings
  def edit
    @user = find_user

    authorize @user
  end

  # Profile settings
  def update
    @user = find_user

    authorize @user

    if @user.update_attributes(user_params)
      flash[:success] = "Your details have been updated."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :location, :bio)
    end

    def set_event_if_coming_from_event
      @organized_event = params[:organized_event] || false
      @attending_event = params[:attending_event] || false

      if @organized_event || @attending_event
        @event = Event.find(@organized_event || @attending_event)
      end
    end

    def set_group_if_coming_from_group
      @organizer_of = params[:organizer_of] || false
      @member_of    = params[:member_of] || false

      if @organizer_of || @member_of
        @group = Group.find(@organizer_of || @member_of)
      end
    end

    def coming_from_group_or_event
      @group || @event
    end

    def add_breadcrumbs
      if @organized_event
        add_event_breadcrumbs_for "Organizer"
      end

      if @attending_event
        add_event_breadcrumbs_for "Attendees", event_attendances_path(@event)
      end

      if @organizer_of || @member_of
        add_group_breadcrumbs_for "Organizers & Members",
          group_members_path(@group)
      end
    end

    def add_event_breadcrumbs_for(title, path = nil)
      @group = @event.group

      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb @event.title, group_event_path(@group, @event)
      add_breadcrumb title, path
      add_breadcrumb @user.name
    end

    def add_group_breadcrumbs_for(title, path = nil)
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb title, path
      add_breadcrumb @user.name
    end

    def store_events
      @attended_events = decorators_for(@user.past_attended_events)
      @upcoming_events = decorators_for(@user.upcoming_attended_events)
      @last_organized_events = decorators_for(@user.last_organized_events)
    end

    def decorators_for(events)
      EventDecorator.collection(events)
    end
end
