class Groups::RolesController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @organizers = User.with_role :organizer, @group
    @members = User.with_role :member, @group
  end

  def create
    authorize :group_role

    @group = find_group
    @user  = User.find(params[:user_id])
    @role  = find_role

    AddGroupRole.call(user: @user, group: @group, role: @role)

    redirect_back fallback_location: group_members_path(@group)
  end

  def destroy
    authorize :group_role

    @group = find_group
    @user  = User.find(params[:id])
    @role  = find_role

    DeleteGroupRole.call(user: @user, group: @group, role: @role)

    redirect_back fallback_location: group_members_path(@group)
  end

  private

    def find_group
      Group.find(params[:group_id])
    end

    def find_role
      params[:role]
    end
end
