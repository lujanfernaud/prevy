# frozen_string_literal: true

class NewGroupInvitationNotifier
  def self.call(invitation)
    new(invitation).call
  end

  def initialize(invitation)
    @invitation      = invitation
    @registered_user = invitation.user
    @group           = invitation.group
  end

  def call
    create_internal_notification if registered_user

    return if registered_user_opted_out_of_group_invitation_emails?

    NotificationMailer.new_group_invitation(invitation).deliver_later
  end

  private

    attr_reader :invitation, :registered_user, :group

    def create_internal_notification
      GroupInvitationNotification.create!(
        user:    registered_user,
        group:   group,
        message: "You have been invited to join #{group.name}!"
      )
    end

    def registered_user_opted_out_of_group_invitation_emails?
      registered_user && !registered_user.group_invitation_emails?
    end
end
