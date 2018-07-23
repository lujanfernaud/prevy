class AddDefaultToEditedAtInTopics < ActiveRecord::Migration[5.1]
  def change
    change_column :topics,
                  :edited_at,
                  :datetime,
                   null: false,
                   default: -> { 'CURRENT_TIMESTAMP' }
  end
end
