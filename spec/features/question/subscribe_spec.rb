require 'rails_helper'

feature 'User subscribes a question', js: true do
  given(:question) { create :question }
  given(:user) { create :user }

  scenario 'unauthorized user can\'t subscribe' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  scenario 'authorized user can subscribe' do
    sign_in(user)
    visit question_path(question)

    within '.question .subscribe' do
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end

  scenario 'authorized user can unsubscribe' do
    question.subscriptions.create(user: user)
    sign_in(user)
    visit question_path(question)

    within '.question .subscribe' do
      click_on 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end
end