class NotificationsController < ApplicationController
  after_action :verify_authorized

  def index
    @user = User.find(params[:user_id])
    @notifications = Notification.where(user: @user).order(created_at: :desc)
    authorize Notification
  end

  def destroy
    @user = User.find(params[:user_id])
    @notification = Notification.find(params[:id])
    authorize @notification

    @notification.delete

    redirect_to user_notifications_path(@user)
  end
end
