class MembershipRequestNotification < Notification
  belongs_to :membership_request

  def link
    return {} unless membership_request

    { text: "Go to request", path: notification_redirecter_path_with_params }
  end

  private

    def notification_redirecter_path_with_params
      Rails.application.routes.url_helpers
           .user_notification_redirecter_path(
             user,
             notification: self,
             membership_request: membership_request
           )
    end
end
