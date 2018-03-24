class NotificationCleanerPolicy < ApplicationPolicy
  def create?
    user == params_user
  end
end
