class UserMembershipPolicy < ApplicationPolicy
  def index?
    user == params_user
  end
end
