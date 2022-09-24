class Style < ApplicationRecord
  include RatingAverage
  extend TopRated
  has_many :beers
  has_many :ratings, through: :beers

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end

  def self.top(count)
    top_ids = Style.joins(:ratings)
                   .group(:id)
                   .average("ratings.score")
                   .sort_by { |s| -s.second }
                   .take(count)
                   .map(&:first)
    Style.where(id: top_ids).sort_by { |s| -s.average_rating }
  end
end
