# frozen_string_literal: true

class Groups::RolesController < ApplicationController
  before_action :find_group
  after_action  :verify_authorized

  def index
    authorize :group_role

    @organizers_and_moderators = find_organizers_and_moderators
    @members = find_members
  end

  def create
    authorize :group_role

    @user = User.find(params[:user_id])
    @role = find_role

    add_role_to_user
    notify_user_with_new_role

    redirect_back fallback_location: group_roles_path(@group)
  end

  def destroy
    authorize :group_role

    @user = User.find(params[:id])
    @role = find_role

    remove_role_from_user
    notify_user_with_removed_role

    redirect_back fallback_location: group_roles_path(@group)
  end

  private

    # TODO: Refactor.
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
      @group ||= Group.find(params[:group_id])
    end

    def find_role
      params[:role]
    end

    def add_role_to_user
      GroupRoleAdder.call(@group, @user, @role)
    end

    def notify_user_with_new_role
      return if @group.sample_group?

      NewGroupRoleNotifier.call(user: @user, group: @group, role: @role)
    end

    def remove_role_from_user
      GroupRoleRemover.call(@group, @user, @role)
    end

    def notify_user_with_removed_role
      return if @group.sample_group?

      RemovedGroupRoleNotifier.call(user: @user, group: @group, role: @role)
    end
end
