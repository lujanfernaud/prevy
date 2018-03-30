class DeclinedMembershipRequestJob < ApplicationJob
  def perform(user, group)
    NotificationMailer.declined_membership_request(user, group).deliver_now
  end
end
