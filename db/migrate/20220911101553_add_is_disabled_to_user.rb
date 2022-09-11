class AddIsDisabledToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_disabled, :boolean
  end
end
