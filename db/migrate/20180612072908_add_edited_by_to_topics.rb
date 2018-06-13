class AddEditedByToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :edited_by_id, :bigint
  end
end
