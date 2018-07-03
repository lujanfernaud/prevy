# frozen_string_literal: true

class DeclinedMembershipRequest
  def self.call(membership_request)
    new(membership_request).call
  end

  def initialize(membership_request)
    @membership_request = membership_request
    @user  = membership_request.user
    @group = membership_request.group
  end

  def call
    MembershipRequestNotification.create(
      user: @user,
      membership_request: @membership_request,
      message: "You membership request for #{@group.name} was declined."
    )

    return unless @user.membership_request_emails?

    NotificationMailer.declined_membership_request(@user, @group).deliver_now
  end
end
