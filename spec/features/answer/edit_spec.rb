require 'rails_helper'

feature 'User edit answer' do

  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given!(:own_answer) { create :answer, :with_files, question: question, author: user }
  given!(:other_user_answer) { create :answer, :with_files, question: question, author: create(:user) }
  given(:updated_answer_data) { attributes_for :answer, :updated }

  describe 'authenticated user' do
    given(:updated_answer_data) { attributes_for :answer, :updated }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can\'t edit other user answer' do
      within "table.answers tr[data-id='#{other_user_answer.id}']" do
        expect(page).to have_text other_user_answer.text
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'can view but can\'t delete other user answer files' do
      within "table.answers tr[data-id='#{other_user_answer.id}']" do
        expect(page).to have_link other_user_answer.files[0].filename.to_s
        expect(page).to_not have_link 'X'
      end
    end

    describe 'no js browser' do
      background do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          click_on 'Edit'
        end
      end

      describe 'correct answer' do
        background do
          within "table.answers tr[data-id='#{own_answer.id}']" do
            fill_in 'answer_text', with: updated_answer_data[:text]
          end
        end

        scenario 'saves correct answer' do
          within "table.answers tr[data-id='#{own_answer.id}']" do
            click_on 'Save'

            expect(page).to have_text updated_answer_data[:text]
            expect(page).to_not have_button 'Save'
          end
        end

        scenario 'saved with attached files' do
          within "table.answers tr[data-id='#{own_answer.id}']" do
            attach_file 'File', ["#{Rails.root}/README.md", "#{Rails.root}/Gemfile.lock"]
            click_on 'Save'

            expect(page).to have_link 'README.md'
            expect(page).to have_link 'Gemfile.lock'
          end
        end
      end

      scenario 'not saves incorrect answer' do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          fill_in 'answer_text', with: ''
          click_on 'Save'

          expect(page).to have_text 'Text can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end

    describe 'js browser', js: true do
      background do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          click_on 'Edit'
        end
      end

      describe 'correct answer' do
        background do
          within "table.answers tr[data-id='#{own_answer.id}']" do
            fill_in 'answer_text', with: updated_answer_data[:text]
          end
        end

        scenario 'saves correct answer' do
          within "table.answers tr[data-id='#{own_answer.id}']" do
            click_on 'Save'

            expect(page).to have_text updated_answer_data[:text]
            expect(page).to_not have_button 'Save'
          end
        end

        scenario 'saved with attached files' do
          within "table.answers tr[data-id='#{own_answer.id}']" do
            attach_file 'File', ["#{Rails.root}/README.md", "#{Rails.root}/Gemfile.lock"]
            click_on 'Save'

            expect(page).to have_link 'README.md'
            expect(page).to have_link 'Gemfile.lock'
          end
        end
      end

      scenario 'not saves incorrect answer' do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          fill_in 'answer_text', with: ''
          click_on 'Save'

          expect(page).to have_text 'Text can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end

    describe 'can delete own answer file' do

      scenario 'no js' do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          expect(page).to have_link own_answer.files[0].filename.to_s
          click_on 'X'

          expect(page).to_not have_link own_answer.files[0].filename.to_s
        end
      end

      scenario 'js', js: true do
        within "table.answers tr[data-id='#{own_answer.id}']" do
          expect(page).to have_link own_answer.files[0].filename.to_s
          click_on 'X'

          expect(page).to_not have_link own_answer.files[0].filename.to_s
        end
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'can\'t edit answer' do
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end

    scenario 'can view but can\'t delete answer files' do
      visit question_path(question)
      expect(page).to have_link other_user_answer.files[0].filename.to_s
      expect(page).to_not have_link 'X'
    end
  end

end
