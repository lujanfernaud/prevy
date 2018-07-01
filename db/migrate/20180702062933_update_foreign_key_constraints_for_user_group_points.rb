class UpdateForeignKeyConstraintsForUserGroupPoints < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :user_group_points, :groups
    remove_foreign_key :user_group_points, :users

    add_foreign_key :user_group_points, :groups, on_delete: :cascade
    add_foreign_key :user_group_points, :users,  on_delete: :cascade
  end
end
