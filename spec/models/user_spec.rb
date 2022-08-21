require 'rails_helper'

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
    let(:user){ User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1" }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score: 10, beer: test_beer
      rating2 = Rating.new score: 20, beer: test_beer

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
