class AddSampleGroupFieldToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :sample_group, :boolean, default: false
  end
end
