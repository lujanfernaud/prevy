class MemberPolicy < ApplicationPolicy
  def index?
    is_member? || group_owner?
  end

  def show?
    is_member? || group_owner?
  end

  private

    def is_member?
      group.members.include? user
    end

    def group_owner?
      user == group.owner
    end

    def group
      @_group ||= record.group
    end
end
