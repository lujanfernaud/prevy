class NotificationsController < ApplicationController
  after_action :verify_authorized

  # User notifications
  def index
    @user = User.find(params[:user_id])
    @notifications = Notification.where(user: @user).order(created_at: :desc)
    authorize Notification
  end

  # Notification settings
  def edit
    authorize :notification

    @user = User.find(params[:user_id])
  end

  # Notification settings
  def update
    authorize :notification

    @user = User.find(params[:user_id])

    if @user.update_attributes(notification_params)
      flash.now[:success] = "Your notification settings have been updated."
    else
      flash.now[:alert] = "Your notification settings could not be updated."
    end

    render :edit
  end

  # Mark notification as read
  def destroy
    @user = User.find(params[:user_id])
    @notification = Notification.find(params[:id])
    authorize @notification

    @notification.delete

    redirect_to user_notifications_path(@user)
  end

  private

    def notification_params
      params.require(:user).permit(:membership_request_emails,
                                   :group_membership_emails,
                                   :group_role_emails)
    end
end
