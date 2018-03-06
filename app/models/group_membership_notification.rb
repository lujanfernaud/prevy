class GroupMembershipNotification < Notification
  belongs_to :group_membership

  def group
    group_membership.group
  end
end
