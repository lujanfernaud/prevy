class AddUpdatedFieldsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :updated_fields, :jsonb, null: false, default: {}
  end
end
