# frozen_string_literal: true

class GroupPolicy < ApplicationPolicy
  def create?
    logged_in? && user.confirmed?
  end

  def update?
    record.owner == user && user.confirmed?
  end

  def destroy?
    record.owner == user && user.confirmed?
  end
end
