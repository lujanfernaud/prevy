class RemoveTopicCommentsCountFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :topic_comments_count
  end
end
