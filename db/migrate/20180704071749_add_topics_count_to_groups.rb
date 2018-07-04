class AddTopicsCountToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :topics_count, :integer, null: false, default: 0

    reversible do |direction|
      direction.up { update_topics_count }
    end
  end

  def update_topics_count
    execute <<-SQL.squish
      UPDATE groups
         SET topics_count = (SELECT count(1)
                               FROM topics
                              WHERE topics.group_id = groups.id)
    SQL
  end
end
