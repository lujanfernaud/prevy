class RenameSentByToSenderIdInGroupInvitations < ActiveRecord::Migration[5.1]
  def change
    rename_column :group_invitations, :sent_by, :sender_id
  end
end
