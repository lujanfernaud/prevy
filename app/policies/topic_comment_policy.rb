# frozen_string_literal: true

class TopicCommentPolicy < ApplicationPolicy
  def create?
    logged_in? && is_member_or_group_owner?
  end

  def update?
    is_author? || is_group_owner_or_moderator?
  end

  def destroy?
    is_author? || is_group_owner_or_moderator?
  end

  private

    def is_member_or_group_owner?
      is_member? || is_group_owner?
    end

    def is_member?
      group.members.include? user
    end

    def is_group_owner?
      group.owner == user
    end

    def is_author?
      record.user == user
    end

    def is_group_owner_or_moderator?
      is_group_owner? || group.moderators.include?(user)
    end

    def group
      record.topic.group
    end
end
