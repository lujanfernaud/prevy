class GroupsController < ApplicationController
  def index
    @groups = Group.where(hidden: false)
                   .paginate(page: params[:page], per_page: 15)
  end

  def new
    @group = Group.new
  end

  def create
    @user  = User.find(session[:user_id])
    @group = @user.owned_groups.new(group_params)

    if @group.save
      flash[:success] = "Yay! You created a group!"
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group  = Group.find(params[:id])
    @events = @group.events.upcoming.includes(:address).limit(9)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

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

    @group.destroy

    flash[:success] = "The group was deleted."
    redirect_to user_groups_path(@user)
  end

  private

    def group_params
      params.require(:group)
            .permit(
              :name, :description, :image,
              :private, :hidden, :all_members_can_create_events
            )
    end
end
