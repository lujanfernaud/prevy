class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :notifications, [:id, :type]
  end
end
