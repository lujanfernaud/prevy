class GroupMembershipsController < ApplicationController
  before_action :find_logged_in_user, only: [:create, :destroy]
  before_action :find_group

  def index
    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb "Members"

    @members = @group.members
  end

  def create
    @user       = User.find(params[:user_id])
    @membership = GroupMembership.create(group: @group, user: @user)

    destroy_membership_request_if_it_exists

    if @logged_in_user == @user
      flash[:success] = "You are now a member of #{@group.name}!"
      redirect_to group_path(@group)
    else
      flash[:success] = "#{@user.name} was accepted as a member of #{@group.name}."
      notify_user_accepted
      redirect_to user_membership_requests_path(@logged_in_user)
    end
  end

  def destroy
    @user       = User.find(params[:id])
    @membership = GroupMembership.find_by(group: @group, user: @user)

    @membership.destroy

    if @logged_in_user == @user
      flash[:success] = "Your membership to '#{@group.name}' has been cancelled."
      redirect_to group_path(@group)
    else
      flash[:success] = "#{@user.name} was removed as a member of '#{@group.name}'."
      notify_user_deleted
      redirect_back fallback_location: root_path
    end
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end

    def find_logged_in_user
      @logged_in_user = User.find(session[:user_id])
    end

    def destroy_membership_request_if_it_exists
      if request_id = params[:request_id]
        MembershipRequest.find(request_id).destroy
      end
    end

    def notify_user_accepted
      NewGroupMembership.call(@membership)
    end

    def notify_user_deleted
      DeletedGroupMembership.call(@membership)
    end
end
