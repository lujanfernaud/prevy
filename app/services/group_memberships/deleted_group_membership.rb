# frozen_string_literal: true

class DeletedGroupMembership
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
      message: "Your membership to #{@group.name} has been cancelled."
    )

    return unless @user.group_membership_emails?

    DeletedGroupMembershipJob.perform_async(@user, @group)
  end
end
