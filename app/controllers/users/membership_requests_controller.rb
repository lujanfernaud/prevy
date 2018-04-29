class Users::MembershipRequestsController < ApplicationController
  def index
    @user   = params[:user_id]
    @groups = Group.where(owner: @user)

    store_membership_requests
  end

  def show
    @membership_request = find_membership_request
    @user = current_user
  end

  private

    def store_membership_requests
      @membership_requests_received = MembershipRequest.where(group: @groups)
      @membership_requests_sent     = MembershipRequest.where(user: @user)
    end

    def find_membership_request
      MembershipRequest.find(params[:id])
    end
end
