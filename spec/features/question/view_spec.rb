require 'rails_helper'

feature 'User can view question' do

  given(:question) { create :question_with_answers, answers_count: 10 }

  describe 'view' do

    background do
      visit question_path(question)
    end

    scenario 'question' do
      expect(page).to have_text question.title
    end

    scenario 'and answers' do
      question.answers.each do |answer|
        expect(page).to have_text answer.text
      end
    end
  end

  scenario 'unauthenticated user can\'t submit answer' do
    expect(has_field? 'Answer').to be_falsey
    expect(has_button? 'Submit answer').to be_falsey
  end

  describe 'and create answer from question page' do
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

end