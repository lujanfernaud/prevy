class GroupsController < ApplicationController
  after_action :verify_authorized, except: [:index]

  def index
    @groups = Group.where(hidden: false)
                   .paginate(page: params[:page], per_page: 15)
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @user  = current_user
    @group = @user.owned_groups.new(group_params)
    authorize @group

    if @group.save
      flash[:success] = "Yay! You created a group!"
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    authorize @group

    upcoming = @group.events.upcoming.includes(:address).limit(9)
    @events  = EventDecorator.collection(upcoming)
  end

  def edit
    @group = Group.find(params[:id])
    authorize @group
  end

  def update
    @group = Group.find(params[:id])
    authorize @group

    if @group.update_attributes(group_params)
      flash[:success] = "The group has been updated."
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  def destroy
    @user  = User.find(params[:user_id])
    @group = Group.find(params[:id])
    authorize @group

    @group.destroy

    flash[:success] = "The group was deleted."
    redirect_to user_groups_path(@user)
  end

  private

    def group_params
      params.require(:group)
            .permit(
              :name, :location, :description, :image,
              :private, :hidden, :all_members_can_create_events
            )
    end
end
