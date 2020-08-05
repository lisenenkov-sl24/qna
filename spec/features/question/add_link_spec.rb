require 'rails_helper'

feature 'User adds links to a new question', js: true do

  given(:user) { create(:user) }
  given(:question_data) { build :question }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: question_data.title
    fill_in 'Body', with: question_data.body

    click_on 'Add link'
  end

  scenario 'saved' do
    link_data = build :link, :thinknetica

    within '.links' do
      fill_in 'Name', with: link_data.name
      fill_in 'Url', with: link_data.url
    end

    click_on 'Ask'

    expect(page).to have_link link_data.name, href: link_data.url
  end

  scenario 'incorrect links not saved' do
    link_data = build :link, :invalid

    within '.links' do
      fill_in 'Name', with: link_data.name
      fill_in 'Url', with: link_data.url
    end

    click_on 'Ask'

    expect(page).to have_text 'Links url has invalid format'
  end


end