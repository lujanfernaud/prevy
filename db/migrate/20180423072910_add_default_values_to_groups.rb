class AddDefaultValuesToGroups < ActiveRecord::Migration[5.1]
  def change
    change_column :groups, :hidden, :boolean, default: false
    change_column :groups, :all_members_can_create_events, :boolean, default: false
  end
end
