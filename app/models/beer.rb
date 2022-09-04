class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :brewery_id, presence: true
  validates :name, presence: true
  validates :style_id, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end
end
