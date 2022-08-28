require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "BeerDestroyer9000" }

  before :each do
    sign_in username: "Pekka", password: "Foobar1"
  end

  after :each do |example|
    view_page_on_exception example
  end

  it "page shows all ratings and their count" do
    create_beer_with_rating user2, score: 10
    create_beer_with_rating user2, score: 30
    create_beer_with_rating user, score: 50
    visit ratings_path
    expect(page).to have_content "3 ratings"
    expect(page).to have_content "anonymous 10 BeerDestroyer9000"
    expect(page).to have_content "anonymous 30 BeerDestroyer9000"
    expect(page).to have_content "anonymous 50 Pekka"
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end
