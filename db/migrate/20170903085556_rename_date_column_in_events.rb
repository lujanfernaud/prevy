class RenameDateColumnInEvents < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :date, :start_date
  end
end
