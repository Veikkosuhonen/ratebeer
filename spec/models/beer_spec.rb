require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:brewery) { FactoryBot.create :brewery }
  let(:style) { FactoryBot.create :style }

  it "is saved if name, style and brewery set" do
    beer = Beer.create name: "Bishe", style: style, brewery: brewery
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved if has no name" do
    Beer.create style: style, brewery: brewery
    expect(Beer.count).to eq(0)
  end

  it "is not saved if has no style" do
    Beer.create name: "Outo bisse", brewery: brewery
    expect(Beer.count).to eq(0)
  end
end
