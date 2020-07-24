require 'rails_helper'

feature 'User can view question' do

  given(:question) { create :question_with_answers, answers_count: 10 }

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

  describe 'and create answer from question page' do
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