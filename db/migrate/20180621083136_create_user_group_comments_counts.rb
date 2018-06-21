class CreateUserGroupCommentsCounts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_group_comments_counts do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end
  end
end
