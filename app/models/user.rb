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
    result = ratings
      .joins(:beer)
      .group(:style)
      .average("ratings.score")

    result.max_by { |it| it.last }&.first
  end

  def favourite_brewery
    result = ratings
      .joins(:beer)
      .group(:brewery_id)
      .average("ratings.score")

    brewery_id = result
                   .max_by { |it| it.last } # order by value (avg score)
                   &.first # take the key (brewery_id)

    Brewery.find_by id: brewery_id
  end
end
