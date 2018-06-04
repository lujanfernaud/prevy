class AddAnnouncementToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :announcement, :boolean, default: false
  end
end
