require 'rails_helper'

feature 'User can create question' do

  describe 'authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'correct question' do
      given(:question_data) { build(:question) }
      background do
        fill_in 'Title', with: question_data.title
        fill_in 'Body', with: question_data.body
      end

      scenario 'saved' do

        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content question_data.title
        expect(page).to have_content question_data.body
      end

      scenario 'saved with attached files' do
        within '.attached-files' do
          attach_file 'File', ["#{Rails.root}/README.md", "#{Rails.root}/Gemfile.lock"]
        end
        click_on 'Ask'

        expect(page).to have_link 'README.md'
        expect(page).to have_link 'Gemfile.lock'
      end

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