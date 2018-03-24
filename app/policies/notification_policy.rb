class NotificationPolicy < ApplicationPolicy
  def index?
    user == params_user
  end

  def destroy?
    record.user == user
  end
end
