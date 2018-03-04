class UserMembershipsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @owned_groups = @user.owned_groups
    @associated_groups = @user.associated_groups
  end
end
