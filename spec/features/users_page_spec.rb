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
    before :each do
      FactoryBot.create :user
    end

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
  end
end
