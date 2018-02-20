class RenameVisibleToHiddenInGroups < ActiveRecord::Migration[5.1]
  def change
    rename_column :groups, :visible, :hidden
  end
end
