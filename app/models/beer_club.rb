class BeerClub < ApplicationRecord
  has_many :memberships, foreign_key: :beerclub_id

  has_many :confirmed_memberships, -> { where is_confirmed: true }, class_name: "Membership", foreign_key: :beerclub_id
  has_many :membership_applications, -> { where is_confirmed: [false, nil] }, class_name: "Membership", foreign_key: :beerclub_id
  has_many :users, through: :confirmed_memberships

  def to_s
    name
  end
end
