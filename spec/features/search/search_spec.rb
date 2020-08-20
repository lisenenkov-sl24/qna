require 'sphinx_helper'

feature 'User adds or removes links to an existing question', js: true, sphinx: true do
  given!(:user1) { create :user }
  given!(:user2) { create :user }
  given!(:question1) { create :question_with_answers, answers_count: 1, author: user1 }
  given!(:question2) { create :question_with_answers, answers_count: 1, author: user2 }
  given!(:comment1) { create :comment, commentable: question1, user: user1 }
  given!(:comment2) { create :comment, commentable: question1.answers[0], user: user2 }

  background do
    visit search_index_path
  end

  scenario 'search all' do
    ThinkingSphinx::Test.run do
      within 'form' do
        fill_in 'text', with: user1.email
        select 'All', from: 'area'
        click_on 'Search'
      end

      save_page

      expect(page).to have_text question1.title
      expect(page).to have_text question1.answers[0].text
      expect(page).to have_text user1.email
      expect(page).to_not have_text user2.email
      expect(page).to_not have_text question2.title
      expect(page).to_not have_text question2.answers[0].text
      expect(page).to have_text comment1.text
      expect(page).to_not have_text comment2.text
    end
  end

  scenario 'search question' do
    ThinkingSphinx::Test.run do
      within 'form' do
        fill_in 'text', with: question1.title
        select 'Question', from: 'area'
        click_on 'Search'
      end

      save_page

      expect(page).to have_text question1.title
      expect(page).to_not have_text question1.answers[0].text
      expect(page).to_not have_text user1.email
      expect(page).to_not have_text user2.email
      expect(page).to_not have_text question2.title
      expect(page).to_not have_text question2.answers[0].text
      expect(page).to_not have_text comment1.text
      expect(page).to_not have_text comment2.text
    end
  end

  scenario 'search answer' do
    ThinkingSphinx::Test.run do
      within 'form' do
        fill_in 'text', with: question1.answers[0].text
        select 'Answer', from: 'area'
        click_on 'Search'
      end

      save_page

      expect(page).to_not have_text question1.title
      expect(page).to have_text question1.answers[0].text
      expect(page).to_not have_text user1.email
      expect(page).to_not have_text user2.email
      expect(page).to_not have_text question2.title
      expect(page).to_not have_text question2.answers[0].text
      expect(page).to_not have_text comment1.text
      expect(page).to_not have_text comment2.text
    end
  end

  scenario 'search comment' do
    ThinkingSphinx::Test.run do
      within 'form' do
        fill_in 'text', with: comment1.text
        select 'Comment', from: 'area'
        click_on 'Search'
      end

      save_page

      expect(page).to_not have_text question1.title
      expect(page).to_not have_text question1.answers[0].text
      expect(page).to_not have_text user1.email
      expect(page).to_not have_text user2.email
      expect(page).to_not have_text question2.title
      expect(page).to_not have_text question2.answers[0].text
      expect(page).to have_text comment1.text
      expect(page).to_not have_text comment2.text
    end
  end

  scenario 'search user' do
    ThinkingSphinx::Test.run do
      within 'form' do
        fill_in 'text', with: user2.email
        select 'User', from: 'area'
        click_on 'Search'
      end

      save_page

      expect(page).to_not have_text question1.title
      expect(page).to_not have_text question1.answers[0].text
      expect(page).to_not have_text user1.email
      expect(page).to have_text user2.email
      expect(page).to_not have_text question2.title
      expect(page).to_not have_text question2.answers[0].text
      expect(page).to_not have_text comment1.text
      expect(page).to_not have_text comment2.text
    end
  end
end
