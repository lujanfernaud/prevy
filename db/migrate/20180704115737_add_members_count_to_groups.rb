class AddMembersCountToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :members_count, :integer, null: false, default: 0

    reversible do |direction|
      direction.up { update_members_count }
    end
  end

  def update_members_count
    execute <<-SQL.squish
      UPDATE groups
         SET members_count = (SELECT count(1)
                                FROM group_memberships
                               WHERE group_memberships.group_id = groups.id)
    SQL
  end
end
