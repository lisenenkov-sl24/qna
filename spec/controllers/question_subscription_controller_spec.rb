require 'rails_helper'

RSpec.describe QuestionSubscriptionController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }

  it 'Unauthorized user can\'t subscribe' do
    expect { post :create, params: { question_id: question }, format: :js }.to_not change question.question_subscriptions, :count
  end


  describe 'Authorized user' do
    before { login user }

    it 'POST #create' do
      expect { post :create, params: { question_id: question }, format: :js }.to change(question.question_subscriptions, :count).by 1
    end

    it 'DELETE #destroy' do
      qs = question.question_subscriptions.create(user: user)

      expect { delete :destroy, params: { question_id: question, id: qs  }, format: :js }.to change(question.question_subscriptions, :count).by(-1)
    end
  end

end
