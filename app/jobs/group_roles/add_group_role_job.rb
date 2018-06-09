class AddGroupRoleJob < ApplicationJob
  def perform(user, group, role)
    NotificationMailer.added_group_role(user, group, role).deliver_now
  end
end
