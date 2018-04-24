module GroupButtonsHelper
  def membership_button(group)
    return request_membership_button_disabled if group.sample_group?
    return log_in_to_request_membership_link  if !logged_in?

    if requested_membership_for group
      membership_requested_button
    else
      request_membership_link_for group
    end
  end

  def request_membership_button_disabled
    button_tag "Request membership", disabled: true,
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def membership_requested_button
    button_tag "Membership requested", disabled: true,
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def request_membership_link_for(group)
    link_to "Request membership", new_group_membership_request_path(group),
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def log_in_to_request_membership_link
    link_to "Log in to request membership", new_user_session_path,
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def requested_membership_for(group)
    current_user.sent_requests.include?(group)
  end

  def see_all_members_link(group, quantity:)
    if group.members.count > quantity
      link_to "See all members", group_members_path(group)
    end
  end

  def see_all_members_button(group, quantity:)
    if group.members.count > quantity
      link_to "See all members", group_members_path(group),
        class: "btn btn-primary btn-lg"
    end
  end
end
