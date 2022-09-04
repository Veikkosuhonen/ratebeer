require 'rails_helper'

describe "Places" do

  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )
    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      Weather.new(temperature: 28)
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("merihaka").and_return(
      [ Place.new( name: "Meribar", id: 1 ), Place.new( name: "Sir Oliver", id: 2 ) ]
    )
    allow(WeatherApi).to receive(:weather_in).with("merihaka").and_return(
      Weather.new(temperature: 28)
    )

    visit places_path
    fill_in('city', with: 'merihaka')
    click_button "Search"

    expect(page).to have_content "Meribar"
    expect(page).to have_content "Sir Oliver"
  end

  it "if none are found by API, a message is shown" do
    allow(BeermappingApi).to receive(:places_in).with("tervalampi").and_return(
      [ ]
    )
    allow(WeatherApi).to receive(:weather_in).with("tervalampi").and_return(
      Weather.new(temperature: -32)
    )

    visit places_path
    fill_in('city', with: 'tervalampi')
    click_button "Search"

    expect(page).to have_content "No locations in tervalampi"
  end
end
