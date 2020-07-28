require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'GET #index' do
    let(:questions) { create_list :question, 3, author: user }

    before { get :index }

    it 'populates questions list' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns @question' do
      expect(assigns(:question)).to eq question

    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login user }
    before { get :new }

    it 'assigns @question to new record' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login user }

    context 'with valid params' do
      let(:create_request) { post :create, params: { question: attributes_for(:question) } }

      it 'saves question to db' do
        expect { create_request }.to change(Question, :count).by(1)
      end

      it 'sets current user as author' do
        create_request
        expect(assigns(:question)).to have_attributes(author: user)
      end

      it 'redirects to question' do
        expect(create_request).to redirect_to assigns(:question)
      end
    end

    context 'with invalid params' do
      let(:create_request) { post :create, params: { question: attributes_for(:question, :invalid_title) } }

      it 'not saves question to db' do
        expect { create_request }.to_not change(Question, :count)
      end

      it 'rerenders new view' do
        expect(create_request).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'by author' do
      before { login user }
      let!(:question) { create :question, author: user }
      let(:delete_request) { delete :destroy, params: { id: question } }

      it 'deletes question from db' do
        expect { delete_request }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        expect(delete_request).to redirect_to questions_path
      end
    end

    context 'by other user' do
      before { login user }
      let(:user2) { create :user }
      let!(:question) { create :question, author: user2 }
      let(:delete_request) { delete :destroy, params: { id: question } }

      it 'not question answer from db' do
        expect { delete_request }.to_not change(Question, :count)
      end

      it 'redirects to questions' do
        expect(delete_request).to redirect_to questions_path
      end
    end
  end
end
