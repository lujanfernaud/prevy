class RenameGroupInvitesToMembershipRequests < ActiveRecord::Migration[5.1]
  def change
    rename_table :group_invites, :membership_requests
  end
end
