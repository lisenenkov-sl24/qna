require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  before { login user }

  describe 'POST #create' do

    context 'with valid params' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves answer to db' do
        expect { create_request }.to change { question.answers.count }.by(1)
      end

      it 'sets current user as author' do
        create_request
        expect(assigns(:answer)).to have_attributes(author: user)
      end

      it 'redirects to question' do
        expect(create_request).to redirect_to question
      end
    end

    context 'with invalid params' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid_text) } }

      it 'not saves answer to db' do
        expect { create_request }.to_not change(Answer, :count)
      end

      it 'rerenders question view' do
        expect(create_request).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'by author' do
      let!(:answer) { create :answer, question: question, author: user }
      let(:delete_request) { delete :destroy, params: { id: answer } }

      it 'deletes answer from db' do
        expect { delete_request }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        expect(delete_request).to redirect_to question
      end
    end

    context 'by other user' do
      let(:user2) { create :user }
      let!(:answer) { create :answer, question: question, author: user2 }
      let(:delete_request) { delete :destroy, params: { id: answer } }

      it 'not deletes answer from db' do
        expect { delete_request }.to_not change(question.answers, :count)
      end

      it 'redirects to question' do
        expect(delete_request).to redirect_to question_path(question)
      end
    end
  end

end
