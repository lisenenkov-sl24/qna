require 'rails_helper'

feature 'User edit question:' do

  given(:user) { create :user }
  given(:question) { create :question, :with_files, author: user }
  given!(:other_user_answer) { create :question, author: create(:user) }
  given!(:own_answer) { create :answer, question: question, author: user }
  given!(:other_user_question) { create :question, :with_files, author: create(:user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'no js browser' do
      background do
        within ".question" do
          click_on 'Edit'
        end
      end

      describe 'correct question' do
        given(:updated) { build(:question, :updated) }
        background do
          within ".question" do
            fill_in 'Title', with: updated.title
            fill_in 'Body', with: updated.body
          end
        end

        scenario 'saves correct question' do

          within ".question" do
            click_on 'Save'

            expect(page).to have_text updated.title
            expect(page).to have_text updated.body
            expect(page).to_not have_button 'Save'
          end
        end

        scenario 'saved with attached files' do
          within ".question" do
            attach_file 'File', ["#{Rails.root}/README.md", "#{Rails.root}/Gemfile.lock"]
            click_on 'Save'

            expect(page).to have_link 'README.md'
            expect(page).to have_link 'Gemfile.lock'
          end
        end
      end

      scenario 'not saves incorrect question' do
        within ".question" do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_text 'Title can\'t be blank'
          expect(page).to have_text 'Body can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end

    describe 'js browser', js: true do
      background do
        within ".question" do
          click_on 'Edit'
        end
      end

      describe 'correct question' do
        given(:updated) { build(:question, :updated) }
        background do
          within ".question" do
            fill_in 'Title', with: updated.title
            fill_in 'Body', with: updated.body
          end
        end

        scenario 'saves correct question' do

          within ".question" do
            click_on 'Save'

            expect(page).to have_text updated.title
            expect(page).to have_text updated.body
            expect(page).to_not have_button 'Save'
          end
        end

        scenario 'saved with attached files' do
          within ".question" do
            attach_file 'File', ["#{Rails.root}/README.md", "#{Rails.root}/Gemfile.lock"]
            click_on 'Save'

            expect(page).to have_link 'README.md'
            expect(page).to have_link 'Gemfile.lock'
          end
        end
      end

      scenario 'not saves incorrect question' do
        within ".question" do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_text 'Title can\'t be blank'
          expect(page).to have_text 'Body can\'t be blank'
          expect(page).to have_button 'Save'
        end
      end
    end

    describe 'can delete own question file' do

      scenario 'no js' do
        within '.question' do
          expect(page).to have_link question.files[0].filename.to_s
          click_on 'X'

          expect(page).to_not have_link question.files[0].filename.to_s
        end
      end

      scenario 'js', js: true do
        within '.question' do
          expect(page).to have_link question.files[0].filename.to_s
          click_on 'X'

          expect(page).to_not have_link question.files[0].filename.to_s
        end
      end
    end
  end

  scenario 'can\'t edit other user question' do
    sign_in(user)
    visit question_path(other_user_question)

    within '.question' do
      expect(page).to have_text other_user_question.title
      expect(page).to have_text other_user_question.body
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'can view but can\'t delete other user question files' do
    sign_in(user)
    visit question_path(other_user_question)
    expect(page).to have_link question.files[0].filename.to_s
    expect(page).to_not have_link 'X'
  end

  scenario 'unauthenticated user can\'t edit question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'unauthenticated user can view but can\'t delete question files' do
    visit question_path(question)
    expect(page).to have_link question.files[0].filename.to_s
    expect(page).to_not have_link 'X'
  end

end
