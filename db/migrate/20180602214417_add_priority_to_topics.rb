class AddPriorityToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :priority, :integer, default: 0
    add_index :topics, :priority
  end
end
