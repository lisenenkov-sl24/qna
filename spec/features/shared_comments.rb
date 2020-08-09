shared_examples :comments do |commentable_var, selector|
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question }
  given(:commentable) { instance_eval(commentable_var) }

  scenario 'unauthorized user can\'t add comments' do
    visit question_path(question)

    within selector do
      expect(page).to_not have_button 'Comment'
    end
  end

  describe 'authorized user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can add comment' do
      comment_data = build :comment
      within selector do
        fill_in 'comment_text', with: comment_data.text
        click_on 'Comment'

        expect(page).to have_text comment_data.text
      end

    end

    scenario 'blocks an answer with errors' do
      within selector do
        click_on 'Comment'

        expect(page).to have_text 'Text can\'t be blank'
      end
    end
  end
end

shared_examples :comments_channels do |commentable_var, selector|
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question }
  given(:commentable) { instance_eval(commentable_var) }
  given(:user) { create(:user) }

  scenario "comment appears on another user's page" do
    Capybara.using_session('guest') do
      visit question_path(question)
    end

    sign_in(user)
    visit question_path(question)

    comment_data = build :comment
    within selector do
      fill_in 'comment_text', with: comment_data.text
      click_on 'Comment'

      expect(page).to have_text comment_data.text
    end

    Capybara.using_session('guest') do
      within selector do
        expect(page).to have_content comment_data.text
      end
    end
  end
end
