require 'rails_helper'

feature 'User edit answer' do

  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given!(:own_answer) { create :answer, question: question, author: user }
  given!(:other_user_answer) { create :answer, question: question, author: create(:user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can\'t edit other user answer' do
      within "table.answers tr[data-id='#{other_user_answer.id}']" do
        expect(page).to have_text other_user_answer.text
        expect(page).to_not have_link 'Edit'
      end
    end

    describe 'no js browser' do
      background do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          click_on 'Edit'
        end
      end

      scenario 'saves correct answer' do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          answer_text = "Answer text #{SecureRandom.uuid}"
          fill_in 'answer_text', with: answer_text
          click_on 'Save'

          expect(page).to have_text answer_text
          expect(page).to_not have_button 'Save'
        end
      end

      scenario 'not saves incorrect answer' do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          fill_in 'answer_text', with: ''
          click_on 'Save'

          expect(page).to have_text 'Text can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end

    describe 'js browser', js: true do
      background do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          click_on 'Edit'
        end
      end

      scenario 'saves correct answer' do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          answer_text = "Answer text #{SecureRandom.uuid}"
          fill_in 'answer_text', with: answer_text
          click_on 'Save'

          expect(page).to have_text answer_text
          expect(page).to_not have_button 'Save'
        end
      end

      scenario 'not saves incorrect answer' do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          fill_in 'answer_text', with: ''
          click_on 'Save'

          expect(page).to have_text 'Text can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end
  end

  scenario 'unauthenticated user can\'t edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

end
