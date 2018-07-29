# frozen_string_literal: true

class Users::NotificationsController < ApplicationController
  after_action :verify_authorized

  # User notifications.
  def index
    authorize :notification

    @user = find_user
    @notifications = @user.notifications
  end

  # Notification settings.
  def edit
    authorize :notification

    @user = find_user
  end

  # Notification settings.
  def update
    authorize :notification

    @user = find_user

    @user.update_attributes(notification_params)

    flash.now[:success] = "Your notification settings have been updated."

    render :edit
  end

  # Mark notification as read.
  def destroy
    @user = find_user
    @notification = Notification.find(params[:id])

    authorize @notification

    @notification.destroy

    redirect_to user_notifications_path(@user)
  end

  private

    def find_user
      User.find(params[:user_id])
    end

    def notification_params
      params.require(:user)
            .permit(:membership_request_emails,
                    :group_membership_emails,
                    :group_role_emails,
                    :group_event_emails,
                    :group_announcement_emails,
                    :group_invitation_emails)
    end
end
