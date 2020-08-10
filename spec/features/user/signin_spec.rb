require 'rails_helper'

feature 'User signing in' do

  given(:user) { create :user }

  scenario 'with valid credentials' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'can\'t with invalid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: "#{user.password}_"

    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  shared_examples :oauth_signin do |provider|
    it "can sign in user with #{provider} account" do
      setup_mock_oauth

      visit new_user_session_path
      click_link "Sign in with #{provider}"

      expect(page).to have_content "Successfully authenticated from #{provider} account."
    end

    it "can handle authentication error" do
      OmniAuth.config.add_mock provider.downcase.to_sym, {}

      visit new_user_session_path
      click_link "Sign in with #{provider}"

      expect(page).to have_content 'Something went wrong'
    end
  end

  describe 'GitHub' do
    it_behaves_like :oauth_signin, 'GitHub'
  end
  describe 'Facebook' do
    it_behaves_like :oauth_signin, 'Facebook'
  end
end
