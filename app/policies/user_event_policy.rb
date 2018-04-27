class UserEventPolicy < ApplicationPolicy
  def index?
    logged_in?
  end
end
