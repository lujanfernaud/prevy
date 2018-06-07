class GroupMembershipNotification < Notification
  belongs_to :group_membership
  belongs_to :group

  def group
    group_membership.group
  end

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
