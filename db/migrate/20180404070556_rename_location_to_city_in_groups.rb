class RenameLocationToCityInGroups < ActiveRecord::Migration[5.1]
  def change
    rename_column :groups, :location, :city
  end
end
