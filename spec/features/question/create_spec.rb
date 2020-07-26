require 'rails_helper'

feature 'User can create question' do

  describe 'authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'saved correct question' do

      question = build(:question)

      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'blocked a question with errors' do

      click_on 'Ask'

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe 'unauthenticated user' do

    scenario 'redirected to login page' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

  end

end