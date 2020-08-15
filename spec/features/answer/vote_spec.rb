require 'rails_helper'

feature 'User votes an answer', js: true do
  given(:question) { create :question_with_answers, answers_count: 5 }
  given(:selector) { "table.answers tr[data-id='#{question.answers[2].id}'] .voting" }

  it_behaves_like 'User votes'
end
