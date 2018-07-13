# frozen_string_literal: true

class Groups::MembershipsController < ApplicationController
  after_action :verify_authorized

  def create
    @group = find_group
    @user  = User.find(params[:user_id])
    @membership = GroupMembership.create(group: @group, user: @user)

    authorize @membership

    destroy_user_sample_content
    destroy_membership_request

    if current_user == @user
      flash[:success] = "You are now a member of #{@group.name}!"
      redirect_to group_path(@group)
    else
      flash[:success] = "#{@user.name} was accepted " \
                        "as a member of #{@group.name}."
      notify_user_accepted
      redirect_to user_membership_requests_path(current_user)
    end
  end

  def destroy
    @group = find_group
    @user  = User.find(params[:id])
    @membership = GroupMembership.find_by(group: @group, user: @user)

    authorize @membership

    @membership.destroy

    if current_user == @user
      flash[:success] = "Your membership to '#{@group.name}' " \
                        "has been cancelled."
      redirect_to group_path(@group)
    else
      flash[:success] = "#{@user.name} was removed " \
                        "as a member of '#{@group.name}'."
      notify_user_deleted
      redirect_back fallback_location: root_path
    end
  end

  private

    def find_group
      Group.find(params[:group_id])
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

      NewGroupMembership.call(@membership)
    end

    def notify_user_deleted
      return if @group.sample_group?

      DeletedGroupMembership.call(@membership)
    end
end
