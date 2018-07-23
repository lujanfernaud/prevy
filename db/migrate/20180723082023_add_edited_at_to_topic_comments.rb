class AddEditedAtToTopicComments < ActiveRecord::Migration[5.1]
  def change
    add_column :topic_comments,
               :edited_at,
               :datetime,
                null: false,
                default: -> { 'CURRENT_TIMESTAMP' }
  end
end
