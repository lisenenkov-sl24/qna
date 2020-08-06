require 'rails_helper'

feature 'User can view rewards' do

  given(:user1) { create :user }
  given(:user2) { create :user }
  given(:question1) { create :question_with_answers, answers_count: 1, author: user1 }
  given(:question2) { create :question_with_answers, answers_count: 1, author: user2 }
  given!(:reward1) { create :reward, question: question1, user: user1, file: upload_file('spec/fixtures/hard.png') }
  given!(:reward2) { create :reward, question: question2, user: user2, file: upload_file('spec/fixtures/easy.png') }

  background do
    sign_in(user1)
    visit rewards_path
  end

  scenario 'sees own reward' do
    expect(page).to have_text question1.title
    expect(page).to have_text reward1.name
    expect(page).to have_css "img[src*='#{reward1.file.filename}']"
  end

  scenario 'not sees other user reward' do
    expect(page).to_not have_text question2.title
    expect(page).to_not have_text reward2.name
    expect(page).to_not have_css "img[src*='#{reward2.file.filename}']"
  end

end
