class GroupOrganizersController < ApplicationController
  after_action :verify_authorized

  def create
    authorize :group_organizer

    @group = find_group
    @user  = User.find(params[:user_id])

    AddGroupOrganizer.call(user: @user, group: @group)

    redirect_back fallback_location: group_members_path(@group)
  end

  def destroy
    authorize :group_organizer

    @group = find_group
    @user  = User.find(params[:id])

    DeleteGroupOrganizer.call(user: @user, group: @group)

    redirect_back fallback_location: group_members_path(@group)
  end

  private

    def find_group
      Group.find(params[:group_id])
    end
end
