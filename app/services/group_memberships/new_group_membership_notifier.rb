# frozen_string_literal: true

class NewGroupMembershipNotifier
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

    NewGroupMembershipJob.perform_async(@user, @group)
  end
end
