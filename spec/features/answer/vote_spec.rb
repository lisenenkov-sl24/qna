require 'rails_helper'

feature 'User votes an answer', js: true do

  given(:question) { create :question_with_answers, answers_count: 5 }
  given(:answer) { question.answers[2] }

  scenario 'can\'t vote own answer' do
    sign_in(question.author)
    visit question_path(question)

    within "table.answers tr[data-id='#{answer.id}'] .voting" do
      expect(page).to_not have_link '+'
    end
  end

  describe 'other user answer' do
    given(:user) { create :user }
    background do
      sign_in(user)
      visit question_path(question)

      within "table.answers tr[data-id='#{answer.id}'] .voting" do
        click_on '+'
      end
    end

    scenario 'voted' do
      within "table.answers tr[data-id='#{answer.id}'] .voting" do
        expect(page).to have_link 'x'
        expect(page).to have_text 1
      end
    end

    scenario 'cancel vote' do
      within "table.answers tr[data-id='#{answer.id}'] .voting" do
        click_on 'x'

        expect(page).to have_link '+'
        expect(page).to have_link '-'
        expect(page).to have_text 0
      end
    end
  end
end
