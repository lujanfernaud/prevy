# frozen_string_literal: true

class UserMembershipDecorator < ApplicationDecorator
  def self.collection(groups)
    groups.map { |group| UserMembershipDecorator.new(group) }
  end

  def organizer_tag(user)
    return unless user_is_organizer_but_not_owner(user)

    h.content_tag :span, "[Organizer]", class: "h6 d-inline-block mb-0"
  end

  def links(user)
    if user.owned_groups.include?(self)
      "#{edit_link} #{links_separator} #{edit_roles_link}".html_safe
    else
      cancel_membership_link(user)
    end
  end

  private

    def user_is_organizer_but_not_owner(user)
      user.has_role?(:organizer, self) && !user.owned_groups.include?(self)
    end

    def edit_link
      if sample_group?
        h.link_to "Edit group", "", class: "text-muted"
      else
        h.link_to "Edit group", url.edit_group_path(self)
      end
    end

    def links_separator
      h.content_tag :span, "|"
    end

    def edit_roles_link
      h.link_to "Edit roles", url.group_roles_path(self)
    end

    def cancel_membership_link(user)
      h.link_to "Cancel membership",
        url.group_membership_path(self, user),
        method: :delete,
        data: {
          confirm: "Are you sure to cancel your membership to '#{name}'?"
        }
    end
end
