# frozen_string_literal: true

class Groups::MembersController < ApplicationController
  include Groups::AuthorizationRedirecter

  before_action :find_group

  def index
    @organizers = @group.organizers.order(name: :desc)
    @members    = @group.members_with_role.order(name: :desc)

    add_breadcrumbs_for_index
  end

  def show
    @user = find_user

    add_breadcrumbs_for_show

    render "users/show"
  end

  private

    def find_group
      @group = GroupDecorator.new(Group.find(params[:group_id]))
    end

    def find_user
      User.find(params[:id])
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
