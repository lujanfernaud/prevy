# frozen_string_literal: true

class Users::MembershipRequestsController < ApplicationController
  def index
    @user   = find_user
    @groups = @user.owned_groups

    @membership_requests_received = find_membership_requests_received
    @membership_requests_sent     = find_membership_requests_sent
  end

  def show
    @user   = find_user
    @groups = @user.owned_groups

    @membership_request           = find_membership_request
    @membership_requests_received = find_membership_requests_received
  end

  private

    def find_user
      User.find(params[:user_id])
    end

    def find_membership_requests_sent
      MembershipRequest.find_sent(@user)
    end

    def find_membership_requests_received
      MembershipRequest.find_received(@user)
    end

    def find_membership_request
      MembershipRequest.find(params[:id])
    end
end
