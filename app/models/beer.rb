class Beer < ApplicationRecord
  include RatingAverage
  extend TopRated
  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :brewery_id, presence: true
  validates :name, presence: true
  validates :style_id, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end

  def self.top(count)
    all.sort_by { |b| -(b.average_rating || 0) }.take count
  end
end
