require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  describe "is not saved when password" do
    let(:user_params) { { username: "Pekka" } }

    it "is nil" do
      user = User.new user_params
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "is too short" do
      user_params[:password] = "kA5"
      user_params[:password_confirmation] = "kA5"
      user = User.new user_params
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "has only letters" do
      user_params[:password] = "kAnanmuna"
      user_params[:password_confirmation] = "kAnanmuna"
      user = User.new user_params
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create :user }
    let(:test_brewery) { FactoryBot.create :brewery }
    let(:test_beer) { FactoryBot.create :beer }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = FactoryBot.create :rating, score: 10, user: user
      rating2 = FactoryBot.create :rating, score: 20, user: user

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "user's favourite beer" do
    let(:user) { FactoryBot.create :user }

    it "is determined by a method" do
      expect(user).to respond_to(:favourite_beer)
    end

    it "doesn't exist if user has no ratings" do
      expect(user.favourite_beer).to be_nil
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create :beer
      FactoryBot.create :rating, score: 20, beer: beer, user: user
      expect(user.favourite_beer).to eq(beer)
    end

    it "is the one with the highest rating if several rated" do
      create_beers_with_many_ratings user, 10, 20, 15, 7, 9
      best = create_beer_with_rating user, score: 25
      expect(user.favourite_beer).to eq(best)
    end
  end

  describe "User's favourite style" do
    let(:user) { FactoryBot.create :user }

    it "is determined by a method" do
      expect(user).to respond_to :favourite_style
    end

    it "doesn't exist if has no ratings" do
      expect(user.favourite_style).to be_nil
    end

    it "is the style of the rated beer if only one rating" do
      create_beer_with_rating user, style: "Ale", score: 50
      expect(user.favourite_style.name).to eq("Ale")
    end

    it "is the style of the highest rated beer if rated beers all have different styles and one rating" do
      create_beer_with_rating user, style: "Stout", score: 46
      create_beer_with_rating user, style: "Porter", score: 48
      create_beer_with_rating user, style: "Dortmunder", score: 47
      expect(user.favourite_style.name).to eq("Porter")
    end

    it "is the style of the beer with the best average rating by user" do
      create_beer_with_many_ratings user, "Lager", 20, 50
      create_beer_with_many_ratings user, "Ale", 40, 45
      expect(user.favourite_style.name).to eq("Ale")
    end

    it "is the style that has the best average rating by user, ignoring what beer is rated" do
      create_beer_with_many_ratings user, "Ale", 26, 27# ok beer
      create_beer_with_many_ratings user, "Ale", 25, 26 # another ok beer
      create_beer_with_many_ratings user, "Lager", 49, 50 # absolutely favourite
      create_beer_with_many_ratings user, "Lager", 2, 1 # absolutely most hated
      expect(user.favourite_style.name).to eq("Ale") # Even though one lager is absolutely user's favourite, they still like ale more on average
    end
  end

  describe "User's favourite brewery" do
    let(:user) { FactoryBot.create :user }
    
    it "is determined by a method" do
      expect(user).to respond_to :favourite_brewery
    end

    it "doesn't exist if has no ratings" do
      expect(user.favourite_brewery).to be_nil
    end
    
    it "is the brewery of the rated beer if one rated" do
      beer = create_beer_with_rating user, score: 40
      expect(user.favourite_brewery).to eq(beer&.brewery)
    end

    it "is the brewery of the best rated beer when rated beers all have different breweries" do
      create_beers_with_many_ratings user, 20, 15, 45
      beer = create_beer_with_rating user, score: 50
      create_beers_with_many_ratings user, 30, 40, 10
      expect(user.favourite_brewery).to eq(beer&.brewery)
    end

    it "is the brewery with beers that user has rated best on average" do
      brewery1 = FactoryBot.create :brewery
      brewery2 = FactoryBot.create :brewery
      brewery3 = FactoryBot.create :brewery
      create_beers_with_many_ratings user, 10, 30, 50, brewery: brewery1 # avg 30
      create_beers_with_many_ratings user, 35, 45, 40, brewery: brewery2 # avg 40
      create_beers_with_many_ratings user, 10, 20, 30, brewery: brewery3 # avg 20
      expect(user.favourite_brewery).to eq(brewery2)
    end
  end
end
