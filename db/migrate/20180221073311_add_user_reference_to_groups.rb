class AddUserReferenceToGroups < ActiveRecord::Migration[5.1]
  def change
    add_reference :groups, :user, foreign_key: true
  end
end
