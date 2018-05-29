class CreateForumComments < ActiveRecord::Migration[5.1]
  def change
    create_table :forum_comments do |t|
      t.references :forum_topic, foreign_key: true
      t.references :user, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
