class AddConfirmedToMembership < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :is_confirmed, :boolean
  end
end
