class Remove < ActiveRecord::Migration[5.1]
  def change
    remove_column :groups, :private
  end
end
