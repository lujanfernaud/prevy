class AddSampleUserFieldToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sample_user, :boolean, default: false
  end
end
