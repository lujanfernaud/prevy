class Users::MembershipsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize :user_membership

    @user = User.find(params[:user_id])
    @owned_groups = @user.owned_groups.includes(:owner).order(:name)
    @associated_groups = @user.associated_groups.includes(:owner).order(:name)
  end
end
