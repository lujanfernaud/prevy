# frozen_string_literal: true

class Groups::MembersController < ApplicationController
  before_action :find_group
  before_action :redirect_to_sign_up, if: :not_authorized?
  before_action :redirect_to_root,    unless: :authorized?

  # Group members
  def index
    @organizers = @group.organizers.order(name: :desc)
    @members = @group.members_with_role.order(name: :desc)

    add_breadcrumbs_for_index
  end

  # Group member profile
  def show
    @user = find_user

    add_breadcrumbs_for_show

    render "users/show"
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end

    def redirect_to_sign_up
      redirect_to new_user_registration_path
    end

    def not_authorized?
      !current_user && !invited_to_group?
    end

    def invited_to_group?
      @_invitation ||= GroupInvitation.find_by(
        group: @group, token: params[:token])
    end

    def redirect_to_root
      redirect_to root_path
    end

    def authorized?
      return true if invited_to_group?

      @group.user_is_authorized? current_user
    end

    def find_user
      User.find(params[:id])
    end

    def member
      Member.new(current_user, @group)
    end

    def add_breadcrumbs_for_index
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Organizers & Members"
    end

    def add_breadcrumbs_for_show
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Organizers & Members", group_members_path(@group)
      add_breadcrumb @user.name
    end
end
