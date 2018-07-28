# frozen_string_literal: true

class RecentMembersQuery
  def self.call(group, limit)
    new(group, limit).call
  end

  def initialize(group, limit)
    @group    = group
    @limit    = limit
    @user_ids = nil
    @members  = nil
  end

  def call
    set_user_ids
    set_members
    sort_members
  end

  private

    attr_reader :group, :limit, :user_ids, :members

    def set_user_ids
      @user_ids = memberships_by_creation_date.map(&:user_id)
    end

    def memberships_by_creation_date
      GroupMembership.confirmed(group).by_creation_date(group).limit(limit)
    end

    def set_members
      @members = group.members.confirmed.where(id: user_ids)
    end

    # When doing a SQL query with a 'WHERE id IN' clause, the result doesn't
    # preserve the order of the records.
    #
    # To fix this, we need to sort the records according to the original list
    # of ids used.
    #
    # https://stackoverflow.com/a/26868980/6212572
    def sort_members
      members.index_by(&:id).values_at(*user_ids)
    end
end
