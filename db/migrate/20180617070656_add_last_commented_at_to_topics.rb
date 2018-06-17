class AddLastCommentedAtToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :last_commented_at, :datetime
    add_index :topics, :last_commented_at
  end
end
