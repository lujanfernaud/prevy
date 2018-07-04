class AddNotificationsCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notifications_count, :integer, null: false, default: 0

    reversible do |direction|
      direction.up { update_notifications_count }
    end
  end

  def update_notifications_count
    execute <<-SQL.squish
      UPDATE users
         SET notifications_count = (SELECT count(1)
                                      FROM notifications
                                     WHERE notifications.user_id = users.id)
    SQL
  end
end
