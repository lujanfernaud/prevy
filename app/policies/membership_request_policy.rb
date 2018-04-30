class MembershipRequestPolicy < NotificationPolicy
  def new?
    logged_in?
  end
end
