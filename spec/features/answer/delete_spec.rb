require 'rails_helper'

feature 'Author deletes answer' do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:question) { create :question, author: user }

  scenario 'can delete own question' do
    answer = create :answer, author: user, question: question

    sign_in(user)
    visit question_path(answer.question)

    expect(find("table.answers/tr[@data-id=#{answer.id}]").has_link? 'Delete').to be_truthy
    find("table.answers/tr[@data-id=#{answer.id}]").click_on 'Delete'

    expect(page).to have_text 'Answer deleted.'
  end

  scenario 'can\'t delete other author question' do
    answer = create :answer, author: user2, question: question

    sign_in(user)
    visit question_path(answer.question)

    expect(find("table.answers/tr[@data-id=#{answer.id}]").has_link? 'Delete').to be_falsey
  end
end