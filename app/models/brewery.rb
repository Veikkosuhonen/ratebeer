class Brewery < ApplicationRecord
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: {
    greater_than_or_equal_to: 1040,
    less_than_or_equal_to: ->(_) { Time.now.year },
    only_integer: true
  }

  def to_s
    name
  end
end
