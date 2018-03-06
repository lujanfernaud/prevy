class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :membership_request, foreign_key: false
      t.references :group_membership, foreign_key: false
      t.string :type
      t.string :message

      t.timestamps
    end
  end
end
