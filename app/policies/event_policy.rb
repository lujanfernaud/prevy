class EventPolicy < ApplicationPolicy
  def index?
    logged_in?
  end

  def show?
    logged_in? && group_member? || group_owner?
  end

  def create?
    user.has_role? :organizer, record.group
  end

  def update?
    record.organizer == user
  end

  def destroy?
    record.organizer == user
  end

  private

    def group_member?
      group.members.include? user
    end

    def group_owner?
      group.owner == user
    end

    def group
      @group ||= record.group
    end
end
