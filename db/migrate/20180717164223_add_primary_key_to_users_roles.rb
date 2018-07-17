class AddPrimaryKeyToUsersRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :users_roles, :id, :primary_key
  end
end
