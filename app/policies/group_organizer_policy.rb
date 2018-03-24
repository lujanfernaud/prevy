class GroupOrganizerPolicy < ApplicationPolicy
  def create?
    logged_in? && group.owner
  end

  def destroy?
    logged_in? && group.owner
  end

  private

    def group
      Group.find(params[:group_id])
    end
end
