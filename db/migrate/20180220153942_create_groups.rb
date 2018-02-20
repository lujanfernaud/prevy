class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :image
      t.boolean :private
      t.boolean :visible
      t.boolean :all_members_can_create_events

      t.timestamps
    end
  end
end
