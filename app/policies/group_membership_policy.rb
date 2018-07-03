# frozen_string_literal: true

class GroupMembershipPolicy < ApplicationPolicy
  def index?
    logged_in? && is_a_group_member
  end

  def create?
    logged_in? && group.owner
  end

  def destroy?
    logged_in? && group.owner
  end

  private

    def is_a_group_member
      user.has_role?(:member, group) || user.has_role?(:organizer, group)
    end

    def group
      Group.find(params[:group_id])
    end
end
