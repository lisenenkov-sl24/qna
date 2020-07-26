require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

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
    before { login user }
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
    before { login user }

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
end
