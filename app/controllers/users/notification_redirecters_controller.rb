# frozen_string_literal: true

class Users::NotificationRedirectersController < ApplicationController
  def new
    @notification = Notification.find(params[:notification])

    destroy_notification_and_redirect_to_resource
  end

  private

    def destroy_notification_and_redirect_to_resource
      resource_path = @notification.resource_path

      @notification.destroy

      redirect_to resource_path
    end
end
