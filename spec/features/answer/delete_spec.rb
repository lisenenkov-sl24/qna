require 'rails_helper'

feature 'User deletes answer' do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:question) { create :question, author: user }

  describe 'no js browser' do
    scenario 'can delete own answer' do
      answer = create :answer, author: user, question: question

      sign_in(user)
      visit question_path(question)

      within "table.answers tr[data-id='#{answer.id}']" do
        click_on 'Delete'
      end

      expect(page).to have_text 'Answer deleted.'
      expect(page).to_not have_text answer.text
    end
  end

  describe 'js browser', js: true do
    scenario 'can delete own answer' do
      answer = create :answer, author: user, question: question

      sign_in(user)
      visit question_path(question)

      within "table.answers tr[data-id='#{answer.id}']" do
        accept_confirm do
          click_on 'Delete'
        end
      end

      expect(page).to_not have_text answer.text
    end
  end

  scenario 'can\'t delete other author answer' do
    create :answer, author: user, question: question
    answer = create :answer, author: user2, question: question

    sign_in(user)
    visit question_path(question)

    within "table.answers tr[data-id='#{answer.id}']" do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'unauthorized can\'t delete any answer' do
    create :answer, author: user, question: question
    create :answer, author: user2, question: question

    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end
