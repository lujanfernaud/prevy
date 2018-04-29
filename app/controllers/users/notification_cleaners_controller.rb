class Users::NotificationCleanersController < ApplicationController
  after_action :verify_authorized

  def create
    authorize :notification_cleaner

    @user = User.find(params[:user_id])

    @user.notifications.delete_all

    redirect_to user_notifications_path(@user)
  end
end
