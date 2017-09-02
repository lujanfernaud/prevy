class AddOrganizerToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :organizer_id, :bigint
    add_index :events, :organizer_id
  end
end
