require "rails_helper"

include Helpers

describe "Beers page" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }

  before :each do
    visit beers_path
  end

  after(:each) do |example|
    view_page_on_exception example
  end

  it "allows to create new beers with name" do
    click_link "New beer"
    fill_in "beer[name]", with: "iso 3"
    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.by 1
    visit beers_path
    expect(page).to have_content "iso 3"
  end

  it "gives an error message if name invalid" do
    visit new_beer_path
    fill_in "beer[name]", with: ""
    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.by 0
    expect(page).to have_content "Name can't be blank"

  end
end