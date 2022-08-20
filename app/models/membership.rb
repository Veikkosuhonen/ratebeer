class Membership < ApplicationRecord
  belongs_to :beer_club, foreign_key: :beerclub_id
  belongs_to :user

  # validates :user_id, numericality: { less_than: 0 }
  validates :user_id, uniqueness: { scope: :beerclub_id }
end
