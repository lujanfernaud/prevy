class AddSlugToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :slug, :string
    add_index :groups, :slug
  end
end
