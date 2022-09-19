require "rails_helper"

include Helpers

describe "Beer clubs page" do
  let!(:beer_club) { FactoryBot.create :beer_club }
  let!(:user) { FactoryBot.create :user, username: "Pekka" }
  let!(:user2) { FactoryBot.create :user, username: "Pentti" }

  before :each do
    sign_in username:"Pekka", password: "Foobar1"
    visit beer_clubs_path
  end

  after(:each) do |example|
    view_page_on_exception example
  end

  it "allows to create new beer clubs with name" do
    click_link "New beer club"
    fill_in "beer_club[name]", with: "jou"
    expect {
      click_button "Create Beer club"
    }.to change { BeerClub.count }.by 1
    visit beer_clubs_path
    expect(page).to have_content "jou"
  end

  it "shows creator as member" do
    click_link "New beer club"
    fill_in "beer_club[name]", with: "jou"
    click_button "Create Beer club"
    visit beer_clubs_path
    click_link "jou"
    expect(page).to have_content "Members"
    expect(page).to have_content "Pekka since"
  end

  it "shows applicants to creator" do
    click_link "New beer club"
    fill_in "beer_club[name]", with: "jou"
    click_button "Create Beer club"

    sign_in username: "Pentti", password: "Foobar1"
    visit beer_clubs_path
    click_link "jou"
    click_button "Join the beer club"
    expect(page).not_to have_content "Membership applications"

    sign_in username: "Pekka", password: "Foobar1"
    visit beer_clubs_path
    click_link "jou"
    expect(page).to have_content "Membership applications"
    expect(page).to have_content "Pentti applied on"
  end

  it "allows member to accept applicants" do
    click_link "New beer club"
    fill_in "beer_club[name]", with: "jou"
    click_button "Create Beer club"

    sign_in username: "Pentti", password: "Foobar1"
    visit beer_clubs_path
    click_link "jou"
    click_button "Join the beer club"
    expect(page).to have_content "You have applied to jou"
    expect(page).not_to have_content "Membership applications"

    sign_in username: "Pekka", password: "Foobar1"
    visit beer_clubs_path
    click_link "jou"
    expect(page).to have_content "Membership applications"
    expect(page).to have_content "Pentti applied on"
    expect {
      click_link "Accept"
    }.to change { Membership.where(is_confirmed: true).size }.by 1
    expect(page).to have_content "Pentti accepted to"
    expect(page).to have_content "Pentti since"
  end
end
