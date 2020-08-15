shared_examples 'User votes' do
  scenario 'can\'t vote own question' do
    sign_in(question.author)
    visit question_path(question)

    within selector do
      expect(page).to_not have_link '+'
    end
  end

  describe 'other user question' do
    given(:user) { create :user }
    background do
      sign_in(user)
      visit question_path(question)

      within selector do
        click_on '+'
      end
    end

    scenario 'voted' do
      within selector do
        expect(page).to have_link 'x'
        expect(page).to have_text 1
      end
    end

    scenario 'cancel vote' do
      within selector do
        click_on 'x'

        expect(page).to have_link '+'
        expect(page).to have_link '-'
        expect(page).to have_text 0
      end
    end
  end
end