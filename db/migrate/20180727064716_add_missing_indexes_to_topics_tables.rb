class AddMissingIndexesToTopicsTables < ActiveRecord::Migration[5.1]
  def change
    add_index :topic_comments, :edited_by_id
    add_index :topics, :edited_by_id
    add_index :topics, [:id, :type]
  end
end
