require 'rails_helper'

feature 'User can view questions' do
  given(:user) { create :user }

  scenario 'questions list' do
    question = create_list :question, 5, author: user

    visit questions_path

    question.each { |q| expect(page).to have_text q.title }
  end

end