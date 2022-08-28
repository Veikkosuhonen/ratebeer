
module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def view_page_on_exception(example)
    if example.exception
      save_and_open_page
    end
  end

  def create_beer_with_brewery(name: "Brewistan", year: 2022)
    brewery = FactoryBot.create :brewery, name: name, year: year
    FactoryBot.create :beer, brewery: brewery
  end

  def create_beer_with_rating(user, style: "Lager", score:, beer: nil, brewery: nil)
    if beer.nil?
      if brewery.nil?
        beer = FactoryBot.create :beer, style: style
      else
        beer = FactoryBot.create :beer, style: style, brewery: brewery
      end
    end

    FactoryBot.create :rating, score: score, beer: beer, user: user
    beer
  end

  def create_beer_with_many_ratings(user, style, *scores, beer: nil)
    scores.each do |score|
      beer = create_beer_with_rating user, style: style, score: score, beer: beer
    end
    beer
  end

  def create_beers_with_many_ratings(user, *scores, brewery: nil)
    scores.each do |score|
      create_beer_with_rating user, score: score, brewery: brewery
    end
  end

end
