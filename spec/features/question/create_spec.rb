require 'rails_helper'

feature 'User can create question' do

  background do
    visit questions_path
    click_on 'Ask question'
  end

  scenario 'saves correct question' do

    question = build(:question)

    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'blocks a question with errors' do

    click_on 'Ask'

    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
  end

end