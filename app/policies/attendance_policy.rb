class AttendancePolicy < ApplicationPolicy
  def create?
    logged_in? && is_a_group_member || group_is_public
  end

  def destroy?
    logged_in?
  end

  private

    def is_a_group_member
      user.has_role? :member, group
    end

    def group_is_public
      !group.private?
    end

    def group
      record.attended_event.group
    end
end
