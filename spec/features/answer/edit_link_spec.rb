require 'rails_helper'

feature 'User adds or removes links to an existing question', js: true do

  given(:link_url) { 'https://thinknetica.com' }
  given(:question) { create(:question_with_answers, answers_count: 1) }
  given(:answer) { question.answers[0] }
  given(:user) { question.author }

  scenario 'add link' do
    sign_in(user)
    visit question_path(question)

    within "table.answers tr[data-id='#{answer.id}']" do
      link_data = build :link, :thinknetica

      click_on 'Edit'
      click_on 'Add link'

      within '.links' do
        fill_in 'Name', with: link_data.name
        fill_in 'Url', with: link_data.url
      end

      click_on 'Save'

      expect(page).to have_link link_data.name, href: link_data.url
    end
  end

  scenario 'deletes link' do
    existing_link = create :link, :github, linkable: answer
    sign_in(user)
    visit question_path(question)

    within "table.answers tr[data-id='#{answer.id}']" do
      expect(page).to have_link existing_link.name, href: existing_link.url

      click_on 'Edit'
      within '.links' do
        click_on 'Remove'
      end

      click_on 'Save'

      expect(page).to_not have_link existing_link.name, href: existing_link.url
    end
  end
end