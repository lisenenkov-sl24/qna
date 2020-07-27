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

end
