require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:question1) { create :question_with_answers, answers_count: 1, author: user1 }
  let(:question2) { create :question_with_answers, answers_count: 1, author: user2 }
  let(:reward1) { create :reward, question: question1, user: user1, file: upload_file('spec/fixtures/hard.png') }
  let(:reward2) { create :reward, question: question2, user: user2, file: upload_file('spec/fixtures/easy.png') }

  describe 'GET #index' do

    before { login(user1) }
    before { get :index }

    it 'populates rewards list' do
      expect(assigns(:rewards)).to match_array([reward1])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

end
