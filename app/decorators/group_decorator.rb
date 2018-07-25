# frozen_string_literal: true

class GroupDecorator < SimpleDelegator
  delegate :class, :is_a?, to: :__getobj__

  def members_title_with_count
    "Members (#{members_count})"
  end

  def organizers_title
    count = organizers.size

    "Organizer".pluralize(count) + role_count(count)
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
end
