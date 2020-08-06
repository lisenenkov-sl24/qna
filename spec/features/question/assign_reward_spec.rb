require 'rails_helper'

feature 'User assign reward to a new question' do

  given(:user) { create(:user) }
  given(:question_data) { build :question }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: question_data.title
    fill_in 'Body', with: question_data.body

    click_on 'Add link'
  end

  scenario 'saved' do
    reward_name = 'best_dj'
    within '.rewards' do
      fill_in 'Reward', with: reward_name
      attach_file 'File', "#{Rails.root}/spec/fixtures/hard.png"
    end

    click_on 'Ask'

    expect(page).to have_text "Reward: #{reward_name}"
  end

  scenario 'incorrect rewards not saved' do

    within '.rewards' do
      attach_file 'File', "#{Rails.root}/spec/fixtures/hard.png"
    end

    click_on 'Ask'

    expect(page).to have_text 'Reward name can\'t be blank'
  end


end