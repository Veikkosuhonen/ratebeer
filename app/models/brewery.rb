class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end

  def average_rating
    ratings.average(:score)
  end
end
