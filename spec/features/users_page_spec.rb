require 'rails_helper'

include Helpers

describe "User" do

  after(:each) do |example|
    view_page_on_exception example
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user[username]', with:'Brian')
    fill_in('user[password]', with:'Secret55')
    fill_in('user[password_confirmation]', with:'Secret55')

    expect{
      click_button('Register')
    }.to change{User.count}.by(1)
  end

  describe "who has signed up" do
    let!(:user) { FactoryBot.create :user }

    it "can signin with right credentials" do
      sign_in username: "Pekka", password: "Foobar1"

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in username: "Pekka", password: "wrong"

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Incorrect username or password'
    end

    it "sees their favourite style on their page" do
      create_beer_with_many_ratings user, "lager", 20, 50
      create_beer_with_many_ratings user, "stout", 45, 45
      sign_in username: "Pekka", password: "Foobar1"
      visit user_path(user)
      expect(page).to have_content "Favourite style: stout"
    end

    it "sees their favourite brewery on their page" do
      create_beers_with_many_ratings user, 20, 15, 45
      beer = create_beer_with_rating user, score: 50
      create_beers_with_many_ratings user, 30, 40, 10
      sign_in username: "Pekka", password: "Foobar1"
      visit user_path(user)
      expect(page).to have_content "Favourite brewery: #{beer&.brewery&.name}"
    end
  end
end
