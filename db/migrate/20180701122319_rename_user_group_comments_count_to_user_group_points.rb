class RenameUserGroupCommentsCountToUserGroupPoints < ActiveRecord::Migration[5.1]
  def change
    rename_table :user_group_comments_counts, :user_group_points
  end
end
