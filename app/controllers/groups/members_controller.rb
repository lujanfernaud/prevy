class Groups::MembersController < ApplicationController
  before_action :redirect_to_sign_up, if: :not_logged_in?
  after_action  :verify_authorized

  # Group members
  def index
    authorize :member

    @group = find_group
    @organizers = @group.organizers
    @members = @group.members_with_role

    add_breadcrumbs_for_index
  end

  # Group member profile
  def show
    @user  = find_user
    @group = find_group
    member = Member.new(@user, @group)

    authorize member

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

    def find_user
      User.find(params[:id])
    end

    def find_group
      Group.find(params[:group_id])
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
