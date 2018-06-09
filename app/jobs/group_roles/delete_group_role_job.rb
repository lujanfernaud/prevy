class DeleteGroupRoleJob < ApplicationJob
  def perform(user, group, role)
    NotificationMailer.deleted_group_role(user, group, role).deliver_now
  end
end
