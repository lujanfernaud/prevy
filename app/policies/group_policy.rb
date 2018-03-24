class GroupPolicy < ApplicationPolicy
  def create?
    logged_in?
  end

  def update?
    record.owner == user
  end

  def destroy?
    record.owner == user
  end
end
