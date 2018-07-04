class AddEventsCountToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :events_count, :integer, null: false, default: 0

    reversible do |direction|
      direction.up { update_events_count }
    end
  end

  def update_events_count
    execute <<-SQL.squish
      UPDATE groups
         SET events_count = (SELECT count(1)
                               FROM events
                              WHERE events.group_id = groups.id)
    SQL
  end
end
