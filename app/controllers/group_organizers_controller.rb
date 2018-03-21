class GroupOrganizersController < ApplicationController
  before_action :find_group

  def create
    @user = User.find(params[:user_id])

    AddGroupOrganizer.call(user: @user, group: @group)

    redirect_back fallback_location: group_members_path(@group)
  end

  def destroy
    @user = User.find(params[:id])

    DeleteGroupOrganizer.call(user: @user, group: @group)

    redirect_back fallback_location: group_members_path(@group)
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end
end
