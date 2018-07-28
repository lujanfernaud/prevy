# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
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
