# frozen_string_literal: true

class Users::NotificationRedirectersController < ApplicationController
  def new
    @user               = User.find(params[:user_id])
    @notification       = Notification.find(params[:notification])
    @membership_request = params[:membership_request]
    @group              = params[:group]
    @topic              = params[:topic]
    @token              = params[:token]

    delete_notification_and_redirect
  end

  private

    def delete_notification_and_redirect
      @notification.delete

      if @membership_request
        redirect_to user_membership_request_path(
          @user, @membership_request) and return
      end

      if @topic
        redirect_to group_topic_path(@group, @topic) and return
      end

      if @group
        redirect_to group_path(@group, token_param) and return
      end
    end

    def token_param
      if @token
        { token: @token }
      else
        ""
      end
    end
end
