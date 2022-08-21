class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  validates :password, confirmation: true, length: { minimum: 4, maximum: 50 },
                       format: { with: /.*([A-Z]\D*\d|\d\D*[A-Z]).*/, message: "must contain 1 upper case and 1 number" }

  def to_s
    username
  end

  def favourite_beer
    ratings.order(score: :desc).limit(1).first&.beer
  end

  def favourite_style
    style = ratings
      .joins(:beer)
      .group(:style)
      .order(score: :desc)
      .average("ratings.score")
      .first # returns [style, avg_score]
    style&.first # style name
  end
end
