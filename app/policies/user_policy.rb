# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    logged_in?
  end

  def update?
    logged_in? && user == record
  end
end
