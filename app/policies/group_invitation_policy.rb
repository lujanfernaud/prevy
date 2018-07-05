# frozen_string_literal: true

class GroupInvitationPolicy < ApplicationPolicy
  def index?
    is_group_owner?
  end

  def new?
    is_group_owner?
  end

  def create?
    is_group_owner?
  end

  private

    def is_group_owner?
      group.owner == user
    end

    def group
      @_group ||= Group.find(params[:group_id])
    end
end
