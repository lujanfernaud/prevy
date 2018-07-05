# frozen_string_literal: true

class GroupInvitationNotification < Notification
  belongs_to :group

  def link
    { text: "Go to group", path: notification_redirecter_path }
  end

  private

    def notification_redirecter_path
      redirecter_path(group: group, token: invitation.token)
    end

    def invitation
      GroupInvitation.where(user: user, group: group).first
    end
end
