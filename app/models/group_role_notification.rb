class GroupRoleNotification < Notification
  belongs_to :group

  def link
    { text: "Go to group", path: notification_redirecter_path_with_params }
  end

  private

    def notification_redirecter_path_with_params
      Rails.application.routes.url_helpers
           .user_notification_redirecter_path(
             user,
             notification: self,
             group: group
           )
    end
end
