require 'rails_helper'

feature 'User adds links to a new answer', js: true do

  given(:question) { create(:question) }
  given(:user) { question.author }
  given(:answer_data) { build :answer }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_text', with: answer_data.text

    click_on 'Add link'
  end

  scenario 'saved' do
    link_data = build :link, :thinknetica

    within '.links' do
      fill_in 'Name', with: link_data.name
      fill_in 'Url', with: link_data.url
    end

    click_on 'Submit answer'

    expect(page).to have_link link_data.name, href: link_data.url
  end

  scenario 'incorrect links not saved' do
    link_data = build :link, :invalid

    within '.links' do
      fill_in 'Name', with: link_data.name
      fill_in 'Url', with: link_data.url
    end

    click_on 'Submit answer'

    expect(page).to have_text 'Links url has invalid format'
  end


end