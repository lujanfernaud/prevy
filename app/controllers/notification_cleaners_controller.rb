class NotificationCleanersController < ApplicationController
  def create
    @user = User.find(params[:user_id])

    @user.notifications.delete_all

    redirect_to user_notifications_path(@user)
  end
end
