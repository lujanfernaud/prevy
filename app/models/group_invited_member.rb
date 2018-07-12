# frozen_string_literal: true

# Creates a user with group membership using an invitation.
class GroupInvitedMember
  def self.create_from(invitation)
    new(invitation).create_invited_member
  end

  def initialize(invitation)
    @invitation = invitation
    @user       = User.new(name: invitation.name, email: invitation.email)
  end

  def create_invited_member
    prepare_user
    add_user_to_group_members
    user.save
  end

  private

    attr_accessor :user
    attr_reader   :invitation

    def prepare_user
      user.skip_sample_content = true
      user.confirmation_token  = invitation.token
      user.skip_confirmation_notification!
    end

    def add_user_to_group_members
      group = Group.find_by(id: invitation.group.id)
      group.members << user
    end
end
