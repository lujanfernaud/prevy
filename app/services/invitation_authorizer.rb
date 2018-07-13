# frozen_string_literal: true

class InvitationAuthorizer
  def self.call(token, group, user)
    new(token, group, user).call
  end

  def initialize(token, group, user)
    @token      = token
    @group      = group
    @user       = user
    @invitation = GroupInvitation.find_by(group: group, token: token)
  end

  def call
    return false unless invitation

    invitation.user == user
  end

  private

    attr_reader :user, :invitation
end
