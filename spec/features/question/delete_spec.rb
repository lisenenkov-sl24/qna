require 'rails_helper'

feature 'User deletes question' do
  given(:user) { create :user }
  given(:user2) { create :user }

  scenario 'can delete own question' do
    question = create :question_with_answers, answers_count: 10, author: user

    sign_in(user)
    visit questions_path
    expect(find("table/tr[@data-id=#{question.id}]").has_link? 'Delete').to be_truthy
    find("table/tr[@data-id=#{question.id}]").click_on 'Delete'

    expect(page).to have_text 'Question deleted.'
  end

  scenario 'can\'t delete other author question' do
    question = create :question_with_answers, answers_count: 10, author: user2

    sign_in(user)
    visit questions_path

    expect(find("table/tr[@data-id=#{question.id}]").has_link? 'Delete').to be_falsey
  end
end