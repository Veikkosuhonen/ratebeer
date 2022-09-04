class Style < ApplicationRecord
  has_many :beers

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
