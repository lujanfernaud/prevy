class AddTopicToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :topic_id, :bigint
    add_index :notifications, :topic_id
  end
end
