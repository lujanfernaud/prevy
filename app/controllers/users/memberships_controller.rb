class Users::MembershipsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize :user_membership

    @user = User.find(params[:user_id])
    @owned_groups = @user.owned_groups.order(:name)
    @associated_groups = @user.associated_groups.order(:name)
  end
end
