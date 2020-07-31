require 'rails_helper'

feature 'User edit question:' do

  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given!(:other_user_answer) { create :question, author: create(:user) }
  given!(:own_answer) { create :answer, question: question, author: user }
  given!(:other_user_question) { create :question, author: create(:user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'no js browser' do
      background do
        within ".question" do
          click_on 'Edit'
        end
      end

      scenario 'saves correct question' do
        updated = build :question, :updated

        within ".question" do
          fill_in 'Title', with: updated.title
          fill_in 'Body', with: updated.body
          click_on 'Save'

          expect(page).to have_text updated.title
          expect(page).to have_text updated.body
          expect(page).to_not have_button 'Save'
        end
      end

      scenario 'not saves incorrect question' do
        within ".question" do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_text 'Title can\'t be blank'
          expect(page).to have_text 'Body can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end

    describe 'js browser', js: true do
      background do
        within ".question" do
          click_on 'Edit'
        end
      end

      scenario 'saves correct question' do
        updated = build :question, :updated

        within ".question" do
          fill_in 'Title', with: updated.title
          fill_in 'Body', with: updated.body
          click_on 'Save'

          expect(page).to have_text updated.title
          expect(page).to have_text updated.body
          expect(page).to_not have_button 'Save'
        end
      end

      scenario 'not saves incorrect question' do
        within ".question" do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_text 'Title can\'t be blank'
          expect(page).to have_text 'Body can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end
  end

  scenario 'can\'t edit other user question' do
    sign_in(user)
    visit question_path(other_user_question)

    within '.question' do
      expect(page).to have_text other_user_question.title
      expect(page).to have_text other_user_question.body
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'unauthenticated user can\'t edit question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

end
