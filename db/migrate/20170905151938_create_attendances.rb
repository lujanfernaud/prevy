class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.bigint :attendee_id
      t.bigint :attended_event_id

      t.timestamps
    end
    add_index :attendances, :attendee_id
    add_index :attendances, :attended_event_id
  end
end
