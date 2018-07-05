# frozen_string_literal: true

class Groups::InvitationsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize GroupInvitation

    @group = find_group
    @invitations = @group.invitations

    add_breadcrumbs_for_index
  end

  def new
    @group = find_group
    @invitation = GroupInvitation.new

    authorize @invitation

    add_breadcrumbs_for_creation
  end

  def create
    @group = find_group
    @invitation = GroupInvitation.new(invitation_params)

    authorize @invitation

    add_breadcrumbs_for_creation

    if @invitation.save
      notify_invited_person
      redirect_to group_invitations_path(@group)
    else
      render :new
    end
  end

  private

    def find_group
      Group.find(params[:group_id])
    end

    def notify_invited_person
      NewGroupInvitationNotification.call(@invitation)
    end

    def invitation_params
      params.require(:group_invitation)
            .permit(:name, :email)
            .merge(group: find_group, sender: current_user)
    end

    def add_breadcrumbs_for_index
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Invitations"
    end

    def add_breadcrumbs_for_creation
      add_breadcrumb @group.name,   group_path(@group)
      add_breadcrumb "Invitations", group_invitations_path(@group)
      add_breadcrumb "Invite someone"
    end
end
