class AddTypeToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :type, :string
  end
end
