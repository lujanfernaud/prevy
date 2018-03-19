class GroupMembershipsController < ApplicationController
  before_action :find_group

  def index
    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb "Members"

    @members = @group.members
  end

  def create
    @user_session = User.find(session[:user_id])
    @user         = User.find(params[:user_id])
    @membership   = GroupMembership.create(group: @group, user: @user)

    destroy_membership_request_if_it_exists

    flash[:success] = "#{@user.name} was accepted as a member of #{@group.name}."
    notify_user_accepted

    redirect_to user_notifications_path(@user_session)
  end

  def destroy
    @user_session = User.find(session[:user_id])
    @user         = User.find(params[:id])
    @membership   = GroupMembership.find_by(group: @group, user: @user)

    @membership.destroy

    if @user_session == @user
      flash[:success] = "Your membership to '#{@group.name}' has been cancelled."
    else
      flash[:success] = "#{@user.name} was removed as a member of '#{@group.name}'."
      notify_user_deleted
    end

    redirect_back fallback_location: root_path
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end

    def destroy_membership_request_if_it_exists
      if params_request_id = params[:request_id]
        MembershipRequest.find(params_request_id).destroy
      end
    end

    def notify_user_accepted
      group_membership_notification(
        "You have been accepted as a member of #{@group.name}!"
      )

      return unless @user.group_membership_emails?

      NotificationMailer.new_group_membership(@user, @group).deliver_now
    end

    def notify_user_deleted
      group_membership_notification(
        "Your membership to #{@group.name} has been cancelled."
      )

      return unless @user.group_membership_emails?

      NotificationMailer.deleted_group_membership(@user, @group).deliver_now
    end

    def group_membership_notification(message)
      GroupMembershipNotification.create(
        user: @user,
        group_membership: @membership,
        message: message
      )
    end
end
