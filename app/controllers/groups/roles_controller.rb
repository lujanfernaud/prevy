class Groups::RolesController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @organizers = User.with_role :organizer, @group
    @members = User.with_role :member, @group
  end
end
