class CreateTopicComments < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_comments do |t|
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
