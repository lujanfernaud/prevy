# frozen_string_literal: true

class GroupInvitationEmailJob < ApplicationJob
  def perform(invitation)
    NotificationMailer.new_group_invitation(invitation).deliver_now
  end
end
