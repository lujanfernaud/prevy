class NewGroupMembershipJob < ApplicationJob
  def perform(user, group)
    NotificationMailer.new_group_membership(user, group).deliver_now
  end
end
