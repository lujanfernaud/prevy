# frozen_string_literal: true

class NewMembershipRequestNotifier
  def self.call(membership_request)
    new(membership_request).call
  end

  def initialize(membership_request)
    @membership_request = membership_request
    @user  = membership_request.user
    @group = membership_request.group
    @owner = @group.owner
  end

  def call
    MembershipRequestNotification.create(
      user: @owner,
      membership_request: @membership_request,
      message: "New membership request from #{@user.name} in #{@group.name}."
    )

    return unless @owner.membership_request_emails?

    NotificationMailer.new_membership_request(@user, @group).deliver_later
  end
end
