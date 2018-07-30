# frozen_string_literal: true

class Groups::MembershipsController < ApplicationController
  before_action :find_group
  after_action  :verify_authorized

  def create
    @user = User.find(params[:user_id])
    @membership = GroupMembership.create(group: @group, user: @user)

    authorize @membership

    destroy_user_sample_content
    destroy_membership_request

    notify_user_accepted
    flash_creation_message_to_group_owner

    redirect_to_resource
  end

  def destroy
    @user = User.find(params[:id])
    @membership = GroupMembership.find_by(group: @group, user: @user)

    authorize @membership

    @membership.destroy

    if membership_owner_is_current_user?
      flash_deletion_message_to_user
      redirect_to group_path(@group)
    else
      notify_user_deleted
      flash_deletion_message_to_group_owner
      redirect_back fallback_location: root_path
    end
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end

    def destroy_user_sample_content
      UserSampleContentDestroyer.call(@user)
    end

    def destroy_membership_request
      if request_id = params[:request_id]
        MembershipRequest.find(request_id).destroy
      end
    end

    def notify_user_accepted
      return if @group.sample_group?

      NewGroupMembershipNotifier.call(@membership)
    end

    def flash_creation_message_to_group_owner
      flash[:success] = "#{@user.name} has been accepted " \
                        "as a member of #{@group.name}."
    end

    def redirect_to_resource
      if current_user.received_requests.empty?
        redirect_to group_path(@group)
      else
        redirect_to user_membership_requests_path(current_user)
      end
    end

    def membership_owner_is_current_user?
      current_user == @user
    end

    def flash_deletion_message_to_user
      flash[:success] = "Your membership to '#{@group.name}' " \
                        "has been cancelled."
    end

    def notify_user_deleted
      return if @group.sample_group?

      DeletedGroupMembershipNotifier.call(@membership)
    end

    def flash_deletion_message_to_group_owner
      flash[:success] = "#{@user.name} has been removed " \
                        "as a member of '#{@group.name}'."
    end
end
