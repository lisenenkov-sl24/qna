require 'rails_helper'

feature 'User deletes question' do
  given(:user) { create :user }
  given(:user2) { create :user }

  scenario 'can delete own question' do
    question = create :question_with_answers, answers_count: 10, author: user

    sign_in(user)
    visit questions_path
    within "table/tr[@data-id=#{question.id}]" do
      click_on 'Delete'
    end

    expect(page).to have_text 'Question deleted.'
    expect(page).to_not have_text question.title
  end

  scenario 'can\'t delete other author question' do
    create :question_with_answers, answers_count: 10, author: user
    question = create :question_with_answers, answers_count: 10, author: user2

    sign_in(user)
    visit questions_path

    within "table/tr[@data-id=#{question.id}]" do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'unauthorized can\'t delete any question' do
    create :question, author: user
    create :question, author: user2

    visit questions_path

    expect(page).to_not have_link 'Delete'
  end
end