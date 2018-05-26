class CreateImagePlaceholders < ActiveRecord::Migration[5.1]
  def change
    create_table :image_placeholders do |t|
      t.bigint :resource_id
      t.string :resource_type
      t.text   :image_base64

      t.timestamps
    end
  end
end
