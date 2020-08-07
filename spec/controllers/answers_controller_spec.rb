require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  before { login user }

  describe 'POST #create' do

    context 'with valid params' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer, :with_files) } }

      it 'saves answer to db' do
        expect { create_request }.to change { question.answers.count }.by(1)
      end

      it 'sets current user as author' do
        create_request
        expect(assigns(:new_answer)).to have_attributes(author: user)
      end

      it 'saves files to db' do
        create_request
        expect(assigns(:new_answer).files.count).to eq 1
      end

      it 'redirects to question' do
        expect(create_request).to redirect_to question
      end

      it 'js: renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(create_request).to render_template :create
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

      it 'js: renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(create_request).to render_template :create
      end
    end
  end

  describe 'POST #best' do
    before { login user }

    context 'by author' do
      let!(:question) { create :question_with_answers, author: user, answers_count: 10 }
      let!(:answer) { question.answers[5] }
      before { post :best, params: { id: answer } }

      it 'updates answer' do
        answer.reload
        expect(answer).to be_best
      end

      it 'redirects to questions' do
        expect(response).to redirect_to question
      end

      it 'js: renders best' do
        post :best, params: { id: answer, format: :js }
        expect(response).to render_template :best
      end
    end

    context 'by other user' do
      let!(:question) { create :question_with_answers, author: create(:user), answers_count: 10 }
      let!(:answer) { question.answers[5] }
      before { post :best, params: { id: answer } }

      it 'not updates answer' do
        answer.reload
        expect(answer).to_not be_best
      end

      it 'redirects to questions' do
        expect(response).to redirect_to question
      end

      it 'js: returns 403' do
        post :best, params: { id: answer, format: :js }
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #vote' do
    before { login user }

    context 'by author' do
      let!(:question) { create :question_with_answers, author: user, answers_count: 10 }
      let!(:answer) { question.answers[5] }
      before { post :vote, params: { id: answer, rate: 1 } }

      it 'not updates vote count' do
        expect(answer.rating).to eq 0
      end

      it 'renders error' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'by other user' do
      let!(:question) { create :question_with_answers, author: create(:user), answers_count: 10 }
      let!(:answer) { question.answers[5] }
      before { post :vote, params: { id: answer, rate: 1 } }

      it 'updates vote count' do
        expect(answer.rating).to eq 1
      end

      it 'renders json' do
        expect(JSON.parse(response.body)).to eq 'rating' => 1, 'rate' => 1
      end
    end
  end

  describe 'DELETE #unvote' do
    before { login user }

    let!(:question) { create :question_with_answers, author: create(:user), answers_count: 10 }
    let!(:answer) { question.answers[5] }
    before do
      answer.vote(user, 1)
      delete :unvote, params: { id: answer }
    end

    it 'updates vote count' do
      expect(answer.rating).to eq 0
    end

    it 'renders json' do
      expect(JSON.parse(response.body)).to eq 'rating' => 0, 'rate' => nil
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns @edit_answer' do
      expect(assigns(:edit_answer)).to eq answer
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:update_data) { attributes_for(:answer, :updated) }
      before { put :update, params: { id: answer, answer: update_data } }

      it 'assigns @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'saves answer to db' do
        answer.reload
        expect(answer).to have_attributes update_data.slice(:text)
      end

      it 'saves files to db' do
        answer.reload
        expect(answer.files.count).to eq 1
      end
    end

    context 'with invalid params' do
      let(:update_data) { attributes_for(:answer, :invalid_text) }
      before { put :update, params: { id: answer, answer: update_data } }

      it 'not saves answer to db' do
        answer.reload
        expect(answer.text).to_not eq update_data[:text]
      end

      it 'rerenders edit view' do
        expect(response).to render_template 'questions/show'
      end

      it 'js: renders update' do
        put :update, params: { id: answer, answer: update_data, format: :js }
        expect(response).to render_template :edit
      end
    end

    context 'by other user' do
      let(:user2) { create :user }
      let!(:answer) { create :answer, question: question, author: user2 }
      let(:update_data) { attributes_for(:answer, :invalid_text) }
      before { put :update, params: { id: answer, answer: update_data } }

      it 'not saves answer to db' do
        answer.reload
        expect(answer.text).to_not eq update_data[:text]
      end

      it 'redirects to question' do
        expect(response).to redirect_to question_path(question)
      end

      it 'js: returns 403' do
        put :update, params: { id: answer, answer: update_data, format: :js }
        expect(response.status).to eq 403
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

      it 'js: renders destroy' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
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

      it 'js: returns 403' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response.status).to eq 403
      end
    end
  end

end
