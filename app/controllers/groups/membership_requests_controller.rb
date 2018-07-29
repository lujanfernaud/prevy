# frozen_string_literal: true

class Groups::MembershipRequestsController < ApplicationController
  before_action :find_group, only: [:new, :create]

  def new
    @membership_request = MembershipRequest.new

    authorize @membership_request
  end

  def create
    @membership_request = MembershipRequest.new(membership_request_params)

    @membership_request.save

    notify_group_owner
    flash_creation_message_to_requester
    redirect_to group_path(@group)
  end

  def destroy
    @membership_request = find_membership_request
    @user  = @membership_request.user
    @group = @membership_request.group

    @membership_request.destroy

    if requester_is_current_user?
      flash_deletion_message_to_requester
    else
      notify_requester
      flash_deletion_message_to_group_owner
    end

    redirect_to user_membership_requests_path(@user)
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end

    # Pundit
    #
    # https://github.com/varvet/pundit#rescuing-a-denied-authorization-in-rails
    def user_not_authorized
      redirect_to new_user_registration_path
    end

    def notify_group_owner
      NewMembershipRequestNotifier.call(@membership_request)
    end

    def flash_creation_message_to_requester
      flash[:success] = "Your request has been sent. " \
                        "You'll be notified when there's any change."
    end

    def find_membership_request
      MembershipRequest.find(params[:id])
    end

    def requester_is_current_user?
      current_user == @user
    end

    def flash_deletion_message_to_requester
      flash[:success] = "Your membership request was deleted."
    end

    def notify_requester
      return if @group.sample_group?

      DeclinedMembershipRequestNotifier.call(@membership_request)
    end

    def flash_deletion_message_to_group_owner
      flash[:success] = "The membership request was deleted."
    end

    def membership_request_params
      params.require(:membership_request)
            .permit(:message)
            .merge(user: current_user, group: @group)
    end
end
