class BeerClub < ApplicationRecord
  has_many :memberships, foreign_key: :beerclub_id
  has_many :users, through: :memberships

  def to_s
    self.name
  end
end
