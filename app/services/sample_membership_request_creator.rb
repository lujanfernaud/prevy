# frozen_string_literal: true

# Creates a sample membership request for every new user.
class SampleMembershipRequestCreator
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user  = user
    @group = user.sample_group
    @membership_request = nil
  end

  def call
    create_membership_request
    create_notification
  end

  private

    attr_reader :user, :group, :membership_request

    def create_membership_request
      @membership_request = MembershipRequest.create(
        user:    sample_user,
        group:   group,
        message: I18n.t("sample_membership_request.message")
      )
    end

    def create_notification
      sender = @membership_request.user

      MembershipRequestNotification.create(
        user: user,
        membership_request: @membership_request,
        message: "New membership request from #{sender.name} in #{group.name}."
      )
    end

    def sample_user
      (SampleUser.all - group.members).sample
    end
end
