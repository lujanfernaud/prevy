class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.bigint :event_id
      t.string :place_name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :post_code
      t.string :country

      t.timestamps
    end
    add_index :addresses, :event_id
  end
end
