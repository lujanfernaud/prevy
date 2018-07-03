class AddCommentsCountToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :comments_count, :integer, null: false, default: 0

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
      UPDATE topics
         SET comments_count = (SELECT count(1)
                                 FROM topic_comments
                                WHERE topic_comments.topic_id = topics.id)
    SQL
  end
end
