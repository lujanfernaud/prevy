# frozen_string_literal: true

class Groups::InvitedMembersController < ApplicationController
  def create
    if registered_user
      create_membership_and_destroy_invitation
      destroy_user_sample_content
      redirect_to group_path(invitation.group, invited: true)
    else
      create_user_and_membership
      redirect_to user_confirmation_path(invited_user_params)
    end
  end

  private

    def registered_user
      @_registered_user ||= invitation.user
    end

    def invitation
      @_invitation ||= GroupInvitation.find_by(token: params[:token])
    end

    def create_membership_and_destroy_invitation
      invitation.group.members << registered_user
      invitation.destroy
    end

    def destroy_user_sample_content
      UserSampleContentDestroyer.call(registered_user)
    end

    # The invitation is destroyed after the account is confirmed.
    # See Users::ConfirmationsController#confirm
    def create_user_and_membership
      return if user_was_created_but_not_confirmed?

      GroupInvitedMember.create_from invitation
    end

    # This is needed in case the process was previously stopped at the
    # account confirmation screen.
    def user_was_created_but_not_confirmed?
      user && !user.confirmed?
    end

    def user
      @_user ||= User.find_by(email: invitation.email)
    end

    def invited_user_params
      {
        confirmation_token: invitation.token,
        group_id:           invitation.group.id,
        invited:            true
      }
    end
end
