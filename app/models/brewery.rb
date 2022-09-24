class Brewery < ApplicationRecord
  include RatingAverage
  extend TopRated

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: {
    greater_than_or_equal_to: 1040,
    less_than_or_equal_to: ->(_) { Time.now.year },
    only_integer: true
  }

  scope :active, -> { where is_active: true }
  scope :retired, -> { where is_active: [nil, false] }

  def to_s
    name
  end

  def beer_count
    beers.size
  end
end
