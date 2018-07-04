class AddAttendeesCountToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :attendees_count, :integer, null: false, default: 0

    reversible do |direction|
      direction.up { update_attendees_count }
    end
  end

  def update_attendees_count
    execute <<-SQL.squish
      UPDATE events
         SET attendees_count = (
           SELECT count(1)
             FROM attendances
            WHERE attendances.attended_event_id = events.id
         )
    SQL
  end
end
