class AddGroupToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :group_id, :bigint
    add_index :notifications, :group_id
  end
end
