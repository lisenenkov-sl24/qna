require 'rails_helper'

describe 'Questions API', type: :request do
  include_context 'API token'
  let!(:questions) { create_list :question_with_answers, 2, :with_files, answers_count: 3 }
  let!(:comments) { create_list :comment, 2, commentable: questions[0] }
  let!(:links) { create_list :link, 2, linkable: questions[0] }

  describe 'GET /api/v1/questions' do
    let(:path) { api_v1_questions_path }
    it_behaves_like 'API Authorizable', :get

    before { do_request :get, path }

    it 'returns all questions' do
      expect(json[:questions].size).to eq questions.size
    end

    it 'returns all public fields' do
      expect(json[:questions][0]).to include jsonize(questions[0], %i[id title body created_at updated_at])
    end

    it 'contains author object' do
      expect(json[:questions][0][:author]).to include jsonize(questions[0].author, %i[id email])
    end

    context 'answers' do
      it 'returns all question answers' do
        expect(json[:questions][0][:answers].size).to eq questions[0].answers.size
      end

      it 'returns all public fields' do
        expect(json[:questions][0][:answers][0]).to include jsonize(questions[0].answers[0], %i[id text created_at updated_at])
      end
    end
  end

  describe 'GET /api/v1/questions/#' do
    let(:path) { api_v1_question_path(questions[0]) }
    it_behaves_like 'API Authorizable', :get
    let(:response_subject) { json[:question] }
    let(:subject) { questions[0] }
    include_context 'Create links and comments'

    before { do_request :get, path }

    it 'returns all public fields' do
      expect(response_subject).to include jsonize(subject, %i[id title body created_at updated_at])
    end

    it_behaves_like 'API Show Detailable'
  end

  describe 'CREATE /api/v1/questions' do
    let(:path) { api_v1_questions_path }

    context 'correct' do
      let(:question_data) { attributes_for :question }
      let(:params) { { question: question_data } }
      it_behaves_like 'API Authorizable', :post

      before { do_request :post, path }

      it 'returns OK' do
        expect(json[:status]).to eq 'ok'
      end

      it 'sets current user as author' do
        expect(assigns(:question)).to have_attributes(author: user)
      end

      it 'saves question data' do
        expect(assigns(:question)).to be_persisted
        expect(assigns(:question)).to have_attributes(question_data.slice(:title, :body))
      end
    end

    context 'incorrect' do
      let(:question_data) { attributes_for :question, :invalid_title }
      let(:params) { { question: question_data } }
      it_behaves_like 'API Authorizable', :post, 422

      before { do_request :post, path }

      it 'returns error' do
        expect(json[:status]).to eq 'error'
        expect(json[:errors]).to_not be_empty
      end

      it 'not saves question data' do
        expect(assigns(:question)).to_not be_persisted
        expect(Question.where(title: question_data[:title])).to_not exist
      end
    end
  end

  describe 'PUT /api/v1/questions/#' do
    let(:path) { api_v1_question_path(question) }

    context 'other question' do
      let(:question) { create :question }
      let(:question_data) { attributes_for :question, :updated }
      let(:params) { { question: question_data } }
      it_behaves_like 'API Authorizable', :put, 403

      before { do_request :put, path }

      it 'not saves question data' do
        question.reload
        expect(question.title).to_not eq question_data[:title]
      end
    end

    context 'own question' do
      let(:question) { create :question, author: user }
      context 'correct' do
        let(:question_data) { attributes_for :question, :updated }
        let(:params) { { question: question_data } }
        it_behaves_like 'API Authorizable', :put

        before { do_request :put, path }

        it 'returns OK' do
          expect(json[:status]).to eq 'ok'
        end

        it 'saves question data' do
          question.reload
          expect(question).to have_attributes(question_data.slice(:title, :body))
        end
      end

      context 'incorrect' do
        let(:question_data) { attributes_for :question, :invalid_title }
        let(:params) { { question: question_data } }
        it_behaves_like 'API Authorizable', :put, 422

        before { do_request :put, path }

        it 'returns error' do
          expect(json[:status]).to eq 'error'
          expect(json[:errors]).to_not be_empty
        end

        it 'not saves question data' do
          question.reload
          expect(question.title).to_not eq question_data[:title]
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/#' do
    let(:path) { api_v1_question_path(question) }

    context 'other question' do
      let(:question) { create :question }
      it_behaves_like 'API Authorizable', :delete, 403

      before { do_request :delete, path }

      it 'not deletes question' do
        expect(Question.where(id: question.id)).to_not be_empty
      end
    end

    context 'own question' do
      let(:question) { create :question, author: user }
      it_behaves_like 'API Authorizable', :delete
    end
    context 'own question' do
      let(:question) { create :question, author: user }

      before { do_request :delete, path }

      it 'returns OK' do
        expect(json[:status]).to eq 'ok'
      end

      it 'deletes question' do
        expect(Question.where(id: question.id)).to be_empty
      end
    end
  end
end
