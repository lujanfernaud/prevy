class AddEditedByToTopicComments < ActiveRecord::Migration[5.1]
  def change
    add_column :topic_comments, :edited_by_id, :bigint
  end
end
