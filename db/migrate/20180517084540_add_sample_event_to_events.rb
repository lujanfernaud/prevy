class AddSampleEventToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :sample_event, :boolean, default: false
  end
end
