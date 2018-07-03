# frozen_string_literal: true

class MembershipRequestPolicy < NotificationPolicy
  def new?
    logged_in?
  end
end
