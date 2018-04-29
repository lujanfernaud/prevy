module User::MembershipRequestsHelper
  def message_for(membership_request)
    if membership_request.message.empty?
      "No message."
    else
      membership_request.message
    end
  end

  def no_membership_requests_for(received, sent)
    if received.none? && sent.none?
      "<h2 class='text-center mt-5 mb-2rem'>
        There are no membership requests.
      </h2>".html_safe
    end
  end

  def membership_requests_link
    return unless membership_requests?

    link_to user_membership_requests_path(current_user),
      class: "dropdown-item" do
      "Membership requests #{membership_requests_badge}".html_safe
    end
  end

  def membership_requests_badge
    return unless membership_requests?

    "<span class='ml-2 badge badge-pill badge-primary align-middle'>
      #{membership_requests_count}
    </span>".html_safe
  end

  def membership_requests?
    current_user.total_membership_requests.count > 0
  end

  def membership_requests_count
    current_user.total_membership_requests.count
  end
end
