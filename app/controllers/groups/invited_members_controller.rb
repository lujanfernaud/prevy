# frozen_string_literal: true

class Groups::InvitedMembersController < ApplicationController
  def create
    @registered_user = invitation.user

    if @registered_user
      prepare_membership_for_registered_user
      redirect_to group_path(invitation.group, invited: true)
    else
      prepare_membership_for_new_user
      redirect_to user_confirmation_path(invited_user_params)
    end
  end

  private

    def invitation
      @_invitation ||= GroupInvitation.find_by(token: params[:token])
    end

    def prepare_membership_for_registered_user
      invitation.group.members << @registered_user
      invitation.destroy
    end

    def prepare_membership_for_new_user
      GroupInvitedMember.create_from invitation
      invitation.destroy
    end

    def invited_user_params
      {
        confirmation_token: invitation.token,
        group_id: invitation.group.id,
        invited: true
      }
    end
end
