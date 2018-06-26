class Groups::MembersController < ApplicationController
  before_action :redirect_to_sign_up, if: :not_logged_in?
  before_action :find_group
  before_action :redirect_to_root, unless: :authorized?

  # Group members
  def index
    @organizers = @group.organizers
    @members = @group.members_with_role

    add_breadcrumbs_for_index
  end

  # Group member profile
  def show
    @user = find_user

    add_breadcrumbs_for_show

    render "users/show"
  end

  private

    def redirect_to_sign_up
      redirect_to new_user_registration_path
    end

    def not_logged_in?
      !current_user
    end

    def find_group
      @group = Group.find(params[:group_id])
    end

    def redirect_to_root
      redirect_to root_path
    end

    def authorized?
      is_member? || is_group_owner?
    end

    def is_member?
      @group.members.include? current_user
    end

    def is_group_owner?
      current_user == @group.owner
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
