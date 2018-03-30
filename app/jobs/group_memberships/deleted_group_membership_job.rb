class DeletedGroupMembershipJob < ApplicationJob
  def perform(user, group)
    NotificationMailer.deleted_group_membership(user, group).deliver_now
  end
end
