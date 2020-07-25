require 'rails_helper'

feature 'User' do

  describe 'Current user' do
    given(:user) { create :user }

    scenario 'signing in with valid credentials' do
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

    scenario 'signing out' do
      sign_in(user)

      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
    end
  end


  scenario 'signing up' do
    new_user = build :user

    visit new_user_registration_path
    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Password confirmation', with: new_user.password

    click_button name: 'commit', value: 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."
  end
end