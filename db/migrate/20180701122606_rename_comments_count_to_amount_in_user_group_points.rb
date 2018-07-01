class RenameCommentsCountToAmountInUserGroupPoints < ActiveRecord::Migration[5.1]
  def change
    rename_column :user_group_points, :comments_count, :amount
  end
end
