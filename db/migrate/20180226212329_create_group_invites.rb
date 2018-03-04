class CreateGroupInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :group_invites do |t|
      t.string :message
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
