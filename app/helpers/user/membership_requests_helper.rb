# frozen_string_literal: true

module User::MembershipRequestsHelper
  def membership_requests_link
    return unless membership_requests?

    link_to user_membership_requests_path(current_user),
      class: "dropdown-item" do
      "Membership requests #{badge}".html_safe
    end
  end

  def badge
    "<span class='ml-2 badge badge-pill badge-primary align-middle'>
      #{membership_requests_count}
    </span>".html_safe
  end

  def membership_requests?
    membership_requests_count > 0
  end

  def membership_requests_count
    current_user.total_membership_requests.size
  end
end
