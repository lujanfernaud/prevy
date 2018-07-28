# frozen_string_literal: true

class AttendancePolicy < ApplicationPolicy
  def create?
    logged_in? && is_a_group_member? || is_sample_group_owner?
  end

  def destroy?
    logged_in?
  end

  private

    def is_a_group_member?
      user.has_role? :member, group
    end

    def is_sample_group_owner?
      group.owner == user
    end

    def group
      @_event ||= Event.find(params[:event_id])
      @_group ||= @_event.group
    end
end
