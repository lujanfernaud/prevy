class AddNameToGroupInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :group_invitations, :name, :string
  end
end
