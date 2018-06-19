class AddDefaultToTypeInTopics < ActiveRecord::Migration[5.1]
  def change
    change_column :topics, :type, :string, default: "Topic"
  end
end
