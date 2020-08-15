require 'rails_helper'

feature 'User votes a question', js: true do
  given(:question) { create :question_with_answers, answers_count: 5 }
  given(:selector) { '.question .voting' }

  it_behaves_like 'User votes'
end
