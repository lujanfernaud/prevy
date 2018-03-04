module MembershipRequestsHelper
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
end
