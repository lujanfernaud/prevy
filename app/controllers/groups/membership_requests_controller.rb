# frozen_string_literal: true

class Groups::MembershipRequestsController < ApplicationController
  def new
    @group = find_group
    @membership_request = MembershipRequest.new

    authorize @membership_request
  end

  def create
    @group = find_group
    @membership_request = MembershipRequest.new(membership_request_params)

    if @membership_request.save
      flash[:success] = "Your request has been sent. " \
                        "You'll be notified when there's any change."
      notify_group_owner
      redirect_to group_path(@group)
    else
      flash[:alert] = "There was a problem. Please try again."
      render :new
    end
  end

  def destroy
    @membership_request = find_membership_request
    @user  = @membership_request.user
    @group = @membership_request.group

    @membership_request.destroy

    if requester_is_current_user?
      flash[:success] = "Your membership request was deleted."
    else
      flash[:success] = "The membership request was deleted."
      notify_requester
    end

    redirect_to user_membership_requests_path(@user)
  end

  private

    def find_membership_request
      MembershipRequest.find(params[:id])
    end

    def find_group
      Group.find(params[:group_id])
    end

    def membership_request_params
      params.require(:membership_request)
            .permit(:message)
            .merge(user: current_user, group: @group)
    end

    def notify_group_owner
      NewMembershipRequestNotifier.call(@membership_request)
    end

    def requester_is_current_user?
      current_user == @user
    end

    def notify_requester
      return if @group.sample_group?

      DeclinedMembershipRequestNotifier.call(@membership_request)
    end

    def user_not_authorized
      redirect_to new_user_registration_path
    end
end
