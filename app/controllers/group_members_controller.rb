class GroupMembersController < ApplicationController
  before_action :find_group, only: :index

  def index
    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb "Members"

    @members = @group.members
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end
end
