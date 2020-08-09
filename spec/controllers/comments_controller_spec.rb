require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  before { login user }

  describe 'POST #create' do

    context 'question with valid params' do
      let(:create_request) { post :create, params: { question_id: question, comment: attributes_for(:comment) } }

      it 'saves comment to db' do
        expect { create_request }.to change { question.comments.count }.by(1)
      end

      it 'sets current user as author' do
        create_request
        expect(assigns(:comment)).to have_attributes(user: user)
      end

      it 'redirects to question' do
        expect(create_request).to redirect_to question
      end

      it 'js: renders create' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js }
        expect(create_request).to render_template :create
      end
    end

    context 'answer with valid params' do
      let(:create_request) { post :create, params: { answer_id: answer, comment: attributes_for(:comment) } }

      it 'saves comment to db' do
        expect { create_request }.to change { answer.comments.count }.by(1)
      end
    end


    context 'with invalid params' do
      let(:create_request) { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid_text) } }

      it 'not saves answer to db' do
        expect { create_request }.to_not change(question.comments, :count)
      end

      it 'rerenders question view' do
        expect(create_request).to render_template 'questions/show'
      end

      it 'js: renders create' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid_text), format: :js }
        expect(create_request).to render_template :create
      end
    end
  end

end
