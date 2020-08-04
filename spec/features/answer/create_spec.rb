require 'rails_helper'

feature 'User can create answer' do

  given(:user) { create :user }
  given(:question) { create :question_with_answers, answers_count: 10, author: user }

  describe 'authenticated user' do
    given(:user) { create :user }
    given(:updated_answer_data) { attributes_for :answer, :updated }

    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'no js browser' do

      describe 'correct answer' do
        background { fill_in 'answer_text', with: updated_answer_data[:text] }

        scenario 'saves correct answer' do
          click_on 'Submit answer'

          expect(page).to have_text updated_answer_data[:text]
        end

        scenario 'saved with attached files' do
          attach_file 'File', ["#{Rails.root}/README.md", "#{Rails.root}/Gemfile.lock"]
          click_on 'Submit answer'

          expect(page).to have_link 'README.md'
          expect(page).to have_link 'Gemfile.lock'
        end
      end

      scenario 'blocks an answer with errors' do
        click_on 'Submit answer'

        expect(page).to have_text 'Text can\'t be blank'
      end
    end

    describe 'js browser', js: true do
      describe 'correct answer' do
        background { fill_in 'answer_text', with: updated_answer_data[:text] }

        scenario 'saves correct answer' do
          click_on 'Submit answer'

          expect(page).to have_text updated_answer_data[:text]
        end

        scenario 'saved with attached files' do
          attach_file 'File', ["#{Rails.root}/README.md", "#{Rails.root}/Gemfile.lock"]
          click_on 'Submit answer'

          expect(page).to have_link 'README.md'
          expect(page).to have_link 'Gemfile.lock'
        end
      end

      scenario 'blocks an answer with errors' do
        click_on 'Submit answer'

        expect(page).to have_text 'Text can\'t be blank'
      end
    end
  end

  scenario 'unauthenticated user can\'t submit answer' do
    visit question_path(question)

    expect(page).to_not have_field 'Answer'
    expect(page).to_not have_button 'Submit answer'
  end

end
