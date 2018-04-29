class Users::NotificationsController < ApplicationController
  after_action :verify_authorized

  # User notifications
  def index
    authorize Notification

    @user = find_user
    @notifications = Notification.where(user: @user).order(created_at: :desc)
  end

  # Notification settings
  def edit
    authorize :notification

    @user = find_user
  end

  # Notification settings
  def update
    authorize :notification

    @user = find_user

    if @user.update_attributes(notification_params)
      flash.now[:success] = "Your notification settings have been updated."
    else
      flash.now[:alert] = "Your notification settings could not be updated."
    end

    render :edit
  end

  # Mark notification as read
  def destroy
    @user = find_user
    @notification = Notification.find(params[:id])

    authorize @notification

    @notification.delete

    redirect_to user_notifications_path(@user)
  end

  private

    def find_user
      User.find(params[:user_id])
    end

    def notification_params
      params.require(:user).permit(:membership_request_emails,
                                   :group_membership_emails,
                                   :group_role_emails,
                                   :group_event_emails)
    end
end
