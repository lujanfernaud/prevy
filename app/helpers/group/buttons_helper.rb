# frozen_string_literal: true

module Group::ButtonsHelper
  def membership_button(group)
    return request_membership_button_disabled if group.sample_group?

    if requested_membership_for? group
      membership_requested_button
    elsif invited?
      join_link
    else
      request_membership_link_for group
    end
  end

  def request_membership_button_disabled
    button_tag "Request membership", disabled: true,
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def requested_membership_for?(group)
    return unless current_user

    current_user.sent_requests.include?(group) ||
      group.members.include?(current_user)
  end

  def membership_requested_button
    button_tag "Membership requested", disabled: true,
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def join_link
    group = params[:id]
    token = session[:token]

    link_to "Yes!", group_invited_members_path(group, token: token),
      method: :post,
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def request_membership_link_for(group)
    link_to "Request membership", new_group_membership_request_path(group),
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def see_all_members_link(group, quantity:)
    if group.members.size > quantity
      link_to "See all members", group_members_path(group)
    end
  end
end
