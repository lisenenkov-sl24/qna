require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question }

  describe 'GET #index' do
    let(:questions) { create_list :question, 3 }

    before { get :index }

    it 'populates questions list' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'assigns @question' do
      expect(assigns(:question)).to eq question

    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns @question to new record' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:create_request) { post :create, params: {question: attributes_for(:question)} }

      it 'saves question to db' do
        expect { create_request }.to change(Question, :count).by(1)
      end

      it 'redirects to question' do
        expect(create_request).to redirect_to assigns(:question)
      end
    end

    context 'with invalid params' do
      let(:create_request) { post :create, params: {question: attributes_for(:question, :invalid_title)} }

      it 'not saves question to db' do
        expect { create_request }.to_not change(Question, :count)
      end

      it 'rerenders new view' do
        expect(create_request).to render_template :new
      end
    end
  end
end
