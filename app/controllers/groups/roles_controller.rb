class Groups::RolesController < ApplicationController
  after_action :verify_authorized

  def index
    authorize :group_role

    @group = find_group
    @organizers_and_moderators = find_organizers_and_moderators
    @members = find_members
  end

  def create
    authorize :group_role

    @group = find_group
    @user  = User.find(params[:user_id])
    @role  = find_role

    AddGroupRole.call(user: @user, group: @group, role: @role)

    redirect_back fallback_location: group_roles_path(@group)
  end

  def destroy
    authorize :group_role

    @group = find_group
    @user  = User.find(params[:id])
    @role  = find_role

    DeleteGroupRole.call(user: @user, group: @group, role: @role)

    redirect_back fallback_location: group_roles_path(@group)
  end

  private

    def find_organizers_and_moderators
      (organizers + moderators).uniq.sort_by { |member| member.name }
    end

    def organizers
      User.with_role :organizer, @group
    end

    def moderators
      User.with_role :moderator, @group
    end

    def find_members
      User.with_role(:member, @group).order(:name)
    end

    def find_group
      Group.find(params[:group_id])
    end

    def find_role
      params[:role]
    end
end
