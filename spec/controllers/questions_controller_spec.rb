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
      let(:create_request) { post :create, params: { question: attributes_for(:question, :with_files) } }

      it 'saves question to db' do
        expect { create_request }.to change(Question, :count).by(1)
      end

      it 'sets current user as author' do
        create_request
        expect(assigns(:question)).to have_attributes(author: user)
      end

      it 'saves files to db' do
        create_request
        expect(assigns(:question).files.count).to eq 1
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

      it 'js: renders create' do
        post :create, params: { question: attributes_for(:question), format: :js }
        expect(create_request).to render_template :create
      end
    end
  end

  describe 'GET #edit' do
    before { login user }
    before { get :edit, params: { id: question } }

    it 'assigns @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    before { login user }
    context 'with valid params' do
      let(:update_data) { attributes_for(:question, :updated) }
      before { put :update, params: { id: question, question: update_data } }

      it 'assigns @question' do
        expect(assigns(:question)).to eq question
      end

      it 'saves question to db' do
        question.reload
        expect(question).to have_attributes update_data.slice(:title, :body)
      end

      it 'saves files to db' do
        question.reload
        expect(question.files.count).to eq 1
      end

      it 'redirects to question' do
        expect(response).to redirect_to assigns(:question)
      end

      it 'js: renders update' do
        post :update, params: { id: question, question: update_data, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid params' do
      let(:update_data) { attributes_for(:question, :invalid_title) }
      before { put :update, params: { id: question, question: update_data } }

      it 'not saves question to db' do
        question.reload
        expect(question).to_not have_attributes update_data.slice(:title, :body)
      end

      it 'rerenders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'by other user' do
      let(:user2) { create :user }
      let!(:question) { create :question, author: user2 }
      let(:update_data) { attributes_for(:question, :invalid_title) }
      before { put :update, params: { id: question, question: update_data } }

      it 'not saves question to db' do
        question.reload
        expect(question).to_not have_attributes update_data.slice(:title, :body)
      end

      it 'redirects to question' do
        expect(question).to redirect_to question
      end

      it 'js: returns 403' do
        put :update, params: { id: question, question: update_data, format: :js }
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #deletefile' do
    let(:question) { create :question, :with_files, author: user }

    it 'deletes file from own question' do
      login user
      delete :deletefile, params: { id: question, file: question.files[0] }
      question.reload
      expect(question.files.count).to eq 0
    end

    it 'keep file from other user question' do
      login create(:user)
      delete :deletefile, params: { id: question, file: question.files[0] }
      question.reload
      expect(question.files.count).to eq 1
    end
  end

  describe 'DELETE #destroy' do
    before { login user }

    context 'by author' do
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
      let(:user2) { create :user }
      let!(:question) { create :question, author: user2 }
      let(:delete_request) { delete :destroy, params: { id: question } }

      it 'not deletes question from db' do
        expect { delete_request }.to_not change(Question, :count)
      end

      it 'redirects to questions' do
        expect(delete_request).to redirect_to questions_path
      end
    end
  end

end
