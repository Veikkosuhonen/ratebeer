class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.sum { |it| it.score } / ratings.count
  end
end
