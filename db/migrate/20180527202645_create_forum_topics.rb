class CreateForumTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :forum_topics do |t|
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title
      t.text :body
      t.string :slug
      t.index :slug

      t.timestamps
    end
  end
end
