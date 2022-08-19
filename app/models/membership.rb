class Membership < ApplicationRecord
  belongs_to :beer_club, foreign_key: :beerclub_id
  belongs_to :user
end
