require 'rails_helper'

feature 'User selects best answer' do

  given(:user) { create :user }
  given(:question) { create :question_with_answers, author: user, answers_count: 10 }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'no js browser' do
      given(:answer) { question.answers[5] }
      background do
        within "table.answers tr[data-id='#{answer.id}']" do
          click_on 'Best'
        end
      end

      scenario 'chose best answer' do

        within "table.answers tr.answer:nth-child(1)" do
          expect(page).to have_text answer.text
          expect(page).to_not have_button 'Best'
        end
      end

      scenario 'chose another best answer' do
        answer2 = question.answers[2]
        within "table.answers tr[data-id='#{answer2.id}']" do
          click_on 'Best'
        end

        within "table.answers tr.answer:nth-child(1)" do
          expect(page).to have_text answer2.text
          expect(page).to_not have_button 'Best'
        end
      end
    end

    describe 'js browser', js: true do
      given(:answer) { question.answers[5] }
      background do
        within "table.answers tr[data-id='#{answer.id}']" do
          click_on 'Best'
        end
      end

      scenario 'chose best answer' do

        within "table.answers tr.answer:nth-child(1)" do
          expect(page).to have_text answer.text
          expect(page).to_not have_button 'Best'
        end
      end

      scenario 'chose another best answer' do
        answer2 = question.answers[2]
        within "table.answers tr[data-id='#{answer2.id}']" do
          click_on 'Best'
        end

        within "table.answers tr.answer:nth-child(1)" do
          expect(page).to have_text answer2.text
          expect(page).to_not have_button 'Best'
        end
      end
    end
  end

  scenario 'authenticated user can\'t chose best answer for other question' do
    sign_in(create :user)
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end

  scenario 'unauthenticated user can\'t chose answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end

end
