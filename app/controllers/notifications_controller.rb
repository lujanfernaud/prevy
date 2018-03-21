class NotificationsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @notifications = Notification.where(user: @user).reverse
  end

  def destroy
    @user = User.find(params[:user_id])
    @notification = Notification.find(params[:id])

    @notification.delete

    redirect_to user_notifications_path(@user)
  end
end
