class AddEditedAtToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :edited_at, :datetime
  end
end
