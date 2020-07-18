require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  it { should rescue_from(ActiveRecord::RecordNotFound).with(:resque_with_answer_not_found) }

  describe 'GET #index' do
    let(:answers) { create_list :answer, 3, question: question }
    before { get :index, params: { question_id: question } }

    it 'populates answers list' do
      create :question_with_answers, answers_count: 2
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns @answer to new record of current question' do
      expect(assigns(:answer)).to be_a_new Answer
      expect(assigns(:answer)).to have_attributes question: question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves answer to db' do
        expect { create_request }.to change { question.answers.count }.by(1)
      end

      it 'redirects to answer' do
        expect(create_request).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid params' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid_text) } }

      it 'not saves answer to db' do
        expect { create_request }.to_not change(Answer, :count)
      end

      it 'rerenders new view' do
        expect(create_request).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
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
        expect(answer.as_json).to include update_data.stringify_keys
      end

      it 'redirects to answer' do
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid params' do
      before { put :update, params: { id: answer, answer: attributes_for(:answer, :invalid_text) } }

      it 'not saves answer to db' do
        answer.reload
        expect(answer.as_json).to include attributes_for(:answer).stringify_keys
      end

      it 'rerenders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer, question: question }
    let(:delete_request) { delete :destroy, params: { id: answer } }

    it 'deletes answer from db' do
      expect { delete_request }.to change(Answer, :count).by(-1)
    end

    it 'redirects to answers' do
      expect(delete_request).to redirect_to question_answers_path(question)
    end
  end
end
