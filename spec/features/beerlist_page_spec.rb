require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new app, browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    end

    Capybara.javascript_driver = :chrome
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)

    visit beerlist_path
  end

  it "shows one known beer", js: true do
    find("table").find('tr:nth-child(1)')
    assert_selector("tr", count: 4)
    expect(page).to have_content "Nikolai"
  end

  it "shows the beer in alphabetic order", js: true do
    find("table").find('tr:nth-child(1)')
    expect(find("#beer-table").first(".tablerow")).to have_content("Fastenbier")
  end

  it "shows the beer in style order when style clicked", js: true do
    find("table").find('tr:nth-child(1)')
    click_on("Style")
    expect(find("#beer-table").first(".tablerow")).to have_content("Lager")
  end

  it "shows the beer in brewery order when brewery clicked", js: true do

    find("table").find('tr:nth-child(1)')
    click_on("Brewery")
    expect(find("#beer-table").first(".tablerow")).to have_content("Ayinger")
  end
end
