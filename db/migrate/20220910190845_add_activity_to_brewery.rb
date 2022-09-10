class AddActivityToBrewery < ActiveRecord::Migration[7.0]
  def change
    add_column :breweries, :is_active, :boolean
    Brewery.all.each { |b| b.is_active = true; b.save; }
  end
end
