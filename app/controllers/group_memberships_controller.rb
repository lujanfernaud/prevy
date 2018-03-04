class GroupMembershipsController < ApplicationController
  before_action :find_group

  def index
    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb "Members"

    @members = @group.members
  end

  def create
    @user    = User.find(params[:user_id])
    @request = MembershipRequest.find(params[:request_id])

    @group.members << @user

    if @request
      @request.destroy
    end

    flash[:success] = "#{@user.name} was accepted as a member of #{@group.name}."
    redirect_back fallback_location: root_path
  end

  def destroy
    @user_session = User.find(session[:user_id])
    @user         = User.find(params[:id])
    @membership   = GroupMembership.where(group: @group, user: @user)

    @membership.destroy_all

    if @user_session == @user
      flash[:success] = "Your membership to '#{@group.name}' was cancelled."
    else
      flash[:success] = "#{@user.name} was removed as a member of '#{@group.name}'."
    end

    redirect_back fallback_location: root_path
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end
end
