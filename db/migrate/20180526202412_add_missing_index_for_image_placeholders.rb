class AddMissingIndexForImagePlaceholders < ActiveRecord::Migration[5.1]
  def change
    add_index :image_placeholders, [:resource_id, :resource_type]
  end
end
