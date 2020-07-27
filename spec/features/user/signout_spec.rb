require 'rails_helper'

feature 'User signing out' do

  given(:user) { create :user }

  scenario 'signing out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

end