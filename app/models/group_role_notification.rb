class GroupRoleNotification < Notification
  belongs_to :group

  def link
    { text: "Go to group", path: notification_redirecter_path }
  end

  private

    def notification_redirecter_path
      redirecter_path(group: group)
    end
end
