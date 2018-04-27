class EventPolicy < ApplicationPolicy
  def show?
    logged_in?
  end

  def create?
    user.has_role? :organizer, record.group
  end

  def update?
    record.organizer == user
  end

  def destroy?
    record.organizer == user
  end
end
