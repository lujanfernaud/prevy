class CreateGroupInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :group_invitations do |t|
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.string :email
      t.string :token
      t.bigint :sent_by

      t.timestamps
    end
    add_index :group_invitations, :sent_by
  end
end
