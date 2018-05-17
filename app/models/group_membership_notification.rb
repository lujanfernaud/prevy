class GroupMembershipNotification < Notification
  belongs_to :group_membership
  belongs_to :group

  def group
    group_membership.group
  end
end
