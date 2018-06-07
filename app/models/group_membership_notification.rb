class GroupMembershipNotification < Notification
  belongs_to :group_membership
  belongs_to :group

  def group
    group_membership.group
  end

  def link
    { text: "Go to group", path: notification_redirecter_path }
  end

  private

    def notification_redirecter_path
      redirecter_path(group: group)
    end
end
