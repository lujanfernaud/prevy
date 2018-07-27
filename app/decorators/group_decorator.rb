# frozen_string_literal: true

class GroupDecorator < ApplicationDecorator
  delegate :name, to: :owner, prefix: true

  def admin_name_or_link(user, token)
    if invited?(user, token)
      h.link_to owner_name, url.group_member_path(self, owner)
    else
      owner_name
    end
  end

  def invited?(user, token)
    return false unless token

    InvitationAuthorizer.call(token, self, user)
  end

  def members_title_with_count
    "Members (#{members_count})"
  end

  def organizers_title
    count = organizers.size

    "Organizer".pluralize(count) + role_count(count)
  end

  def membership_button(user, token)
    if requested_membership?(user)
      membership_requested_button
    elsif invited?(user, token)
      join_link(token)
    else
      request_membership_link
    end
  end

  def join_link(token)
    h.link_to "Yes!", url.group_invited_members_path(self, token: token),
      method: :post,
      class: "btn btn-primary btn-block btn-lg mt-3"
  end

  def see_all_members_link(quantity: Group::RECENT_MEMBERS)
    if members_count > quantity
      h.link_to "See all members", url.group_members_path(self)
    end
  end

  def create_event_button_authorized?(user)
    return true if sample_group?

    user&.has_role?(:organizer, self) && user&.confirmed?
  end

  def top_members_selection
    if members_with_role.size > Group::TOP_MEMBERS
      top_members
    else
      top_members(limit: Group::TOP_MEMBERS / 2)
    end
  end

  def user_points(user)
    "(#{user.group_points_amount(self)} " \
    "#{"point".pluralize(user.group_points_amount(self))})"
  end

  private

    def role_count(count)
      return "" unless count > 1

      " (#{count})"
    end

    def request_membership_button_disabled
      h.button_tag "Request membership", disabled: true,
        class: "btn btn-primary btn-block btn-lg mt-3"
    end

    def requested_membership?(user)
      return unless user

      user.sent_requests.include?(self) || members.include?(user)
    end

    def membership_requested_button
      h.button_tag "Membership requested", disabled: true,
        class: "btn btn-primary btn-block btn-lg mt-3"
    end

    def request_membership_link
      h.link_to "Request membership",
        url.new_group_membership_request_path(self),
        class: "btn btn-primary btn-block btn-lg mt-3"
    end
end
