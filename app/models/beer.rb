class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  validates :brewery_id, presence: true
  validates :name, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end
end
