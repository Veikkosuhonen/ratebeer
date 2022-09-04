class UpdateBeerStyles < ActiveRecord::Migration[7.0]
  def up
    # populate styles
    Beer.select(:style).distinct(:style).each { |beer|
      Style.create name: beer.style
    }

    rename_column :beers, :style, 'old_style'

    add_reference :beers, :style, foreign_key: true

    Beer.all.each do |beer|
      beer[:style_id] = Style.find_by(name: beer[:old_style]).id
      beer.save
    end
  end
end
