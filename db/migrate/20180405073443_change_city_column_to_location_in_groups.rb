class ChangeCityColumnToLocationInGroups < ActiveRecord::Migration[5.1]
  def change
    rename_column :groups, :city, :location
  end
end
