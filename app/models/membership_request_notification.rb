class MembershipRequestNotification < Notification
  belongs_to :membership_request

  def link
    return {} if !membership_request || membership_request_declined?

    { text: "Go to request", path: notification_redirecter_path }
  end

  private

    def membership_request_declined?
      message.match(/declined/)
    end

    def notification_redirecter_path
      redirecter_path(membership_request: membership_request)
    end
end
