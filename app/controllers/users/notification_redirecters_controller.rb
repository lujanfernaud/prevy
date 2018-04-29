class Users::NotificationRedirectersController < ApplicationController
  def new
    @user               = User.find(params[:user_id])
    @notification       = Notification.find(params[:notification])
    @membership_request = params[:membership_request]
    @group              = params[:group]

    unless @membership_request || @group
      return_to_user_notifications
    end

    delete_notification_and_redirect
  end

  private

    def return_to_user_notifications
      flash[:alert] = "The redirection could not be completed."
      redirect_to user_notifications_path(@user) and return
    end

    def delete_notification_and_redirect
      @notification.delete

      if @membership_request
        redirect_to user_membership_request_path(
          @user, @membership_request) and return
      end

      if @group
        redirect_to group_path(@group) and return
      end
    end
end
