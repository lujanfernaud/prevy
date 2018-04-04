class AddLocationToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :location, :string
    add_index :groups, :location
  end
end
