class AddWebsiteToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :website, :string
  end
end
