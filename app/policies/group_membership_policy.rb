class GroupMembershipPolicy < ApplicationPolicy
  def index?
    logged_in? && is_a_group_member || group_is_public
  end

  def create?
    if group.private?
      logged_in? && group.owner
    else
      logged_in?
    end
  end

  def destroy?
    if group.private?
      logged_in? && group.owner
    else
      logged_in?
    end
  end

  private

    def is_a_group_member
      user.has_role?(:member, group) || user.has_role?(:organizer, group)
    end

    def group_is_public
      !group.private?
    end

    def group
      Group.find(params[:group_id])
    end
end
