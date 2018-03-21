class NewGroupMembership
  def self.call(group_membership)
    new(group_membership).call
  end

  def initialize(group_membership)
    @group_membership = group_membership
    @user  = group_membership.user
    @group = group_membership.group
  end

  def call
    GroupMembershipNotification.create(
      user: @user,
      group_membership: @group_membership,
      message: "You have been accepted as a member of #{@group.name}!"
    )

    return unless @user.group_membership_emails?

    NotificationMailer.new_group_membership(@user, @group).deliver_now
  end
end
