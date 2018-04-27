class AttendancePolicy < ApplicationPolicy
  def index?
    logged_in?
  end

  def create?
    logged_in? && is_a_group_member
  end

  def destroy?
    logged_in?
  end

  private

    def is_a_group_member
      user.has_role? :member, group
    end

    def group
      record.attended_event.group
    end
end
