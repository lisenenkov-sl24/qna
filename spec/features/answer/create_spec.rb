require 'rails_helper'

feature 'User can create answer' do

  given(:user) { create :user }
  given(:question) { create :question_with_answers, answers_count: 10, author: user }

  describe 'authenticated user' do
    given(:user) { create :user }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'saves correct answer' do
      answer_text = "Answer text #{SecureRandom.uuid}"
      fill_in 'Answer', with: answer_text
      click_on 'Submit answer'

      expect(page).to have_text answer_text
    end

    scenario 'blocks an answer with errors' do
      click_on 'Submit answer'

      expect(page).to have_text 'Text can\'t be blank'
    end
  end

  scenario 'unauthenticated user can\'t submit answer' do
    expect(page).to_not have_field 'Answer'
    expect(page).to_not have_button 'Submit answer'
  end

end
