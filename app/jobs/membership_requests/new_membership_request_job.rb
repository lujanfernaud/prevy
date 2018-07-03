# frozen_string_literal: true

class NewMembershipRequestJob < ApplicationJob
  def perform(user, group)
    NotificationMailer.new_membership_request(user, group).deliver_now
  end
end
