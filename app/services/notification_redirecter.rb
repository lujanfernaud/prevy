# frozen_string_literal: true

# Returns the notification redirecter path used for the resource link
# of the notification.
class NotificationRedirecter

  def self.path(notification, **params)
    Rails.application.routes.url_helpers
         .user_notification_redirecter_path(
           notification.user,
           { notification: notification }.merge(params)
         )
  end

end
