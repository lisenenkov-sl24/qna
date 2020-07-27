require 'rails_helper'

feature 'User can view question' do

  given(:user) { create :user }
  given(:question) { create :question_with_answers, answers_count: 10, author: user }

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

end
