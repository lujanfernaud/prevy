# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :find_group, only: [:show, :edit, :update, :destroy]
  before_action :redirect_to_root_if_not_own_sample_group, only: [:show]
  after_action  :verify_authorized, except: [:index]

  def index
    @groups = store_unhidden_groups
  end

  def show
    @events = store_upcoming_events
    @events_count = @group.events.upcoming.size
    @topics = @group.topics_prioritized(normal_topics_limit: 5)
    @unhidden_groups = unhidden_groups_selection_without @group

    authorize @group
  end

  def new
    @group = Group.new

    authorize @group
  end

  def edit
    authorize @group
  end

  def create
    @user  = current_user
    @group = @user.owned_groups.new(group_params)

    authorize @group

    if @group.save
      destroy_user_sample_group
      flash[:success] = "Yay! You created a group!"
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def update
    authorize @group

    if @group.update_attributes(group_params)
      flash[:success] = "The group has been updated."
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:user_id])

    authorize @group

    @group.destroy

    flash[:success] = "The group was deleted."
    redirect_to user_groups_path(@user)
  end

  private

    def find_group
      @group = Group.find(params[:id])
    end

    def redirect_to_root_if_not_own_sample_group
      return unless @group.sample_group? && not_owned_by_current_user?

      redirect_to root_path
    end

    def not_owned_by_current_user?
      @group.owner != current_user
    end

    def store_unhidden_groups
      Group.includes(:image_placeholder)
           .unhidden
           .order(created_at: :desc)
           .paginate(page: params[:page], per_page: 15)
    end

    def store_upcoming_events
      upcoming = @group.events.upcoming.limit(9)
      EventDecorator.collection(upcoming)
    end

    def unhidden_groups_selection_without(group)
      Group.unhidden_without(group).random_selection(3)
    end

    def destroy_user_sample_group
      if sample_group = @user.sample_group
        sample_group.destroy
      end
    end

    def group_params
      params.require(:group)
            .permit(
              :name, :location, :description, :image,
              :hidden, :all_members_can_create_events
            )
    end
end
