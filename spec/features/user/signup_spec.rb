require 'rails_helper'

feature 'User signing up' do

  scenario 'signing up' do
    new_user = build :user

    visit new_user_registration_path
    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Password confirmation', with: new_user.password

    click_button name: 'commit', value: 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario 'signing up with oauth' do

  end
end