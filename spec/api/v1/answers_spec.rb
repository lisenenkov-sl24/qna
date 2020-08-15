require 'rails_helper'

describe 'Answers API', type: :request do
  include_context 'API token'
  let!(:question) { create :question }
  let!(:answers) { create_list :answer, 3, :with_files, question: question }

  describe 'GET /api/v1/questions/#/answers' do
    let(:path) { api_v1_question_answers_path(question) }
    it_behaves_like 'API Authorizable', :get

    before { do_request :get, path }

    it 'returns all answers' do
      expect(json[:answers].size).to eq question.answers.size
    end

    it 'returns all public fields' do
      expect(json[:answers][0]).to include jsonize(answers[0], %i[id text created_at updated_at])
    end

    it 'contains author object' do
      expect(json[:answers][0][:author]).to include jsonize(answers[0].author, %i[id email])
    end
  end

  describe 'GET /api/v1/answers/#' do
    let(:path) { api_v1_answer_path(answers[0]) }
    it_behaves_like 'API Authorizable', :get
    let(:response_subject) { json[:answer] }
    let(:subject) { answers[0] }
    include_context 'Create links and comments'

    before { do_request :get, path }

    it 'returns all public fields' do
      expect(response_subject).to include jsonize(subject, %i[id text created_at updated_at])
    end

    it_behaves_like 'API Show Detailable'
  end

  describe 'CREATE /api/v1/questions/#/answers' do
    let(:path) { api_v1_question_answers_path(question) }

    context 'correct' do
      let(:answer_data) { attributes_for :answer }
      let(:params) { { answer: answer_data } }
      it_behaves_like 'API Authorizable', :post

      before { do_request :post, path }

      it 'returns OK' do
        expect(json[:status]).to eq 'ok'
      end

      it 'sets current user as author' do
        expect(assigns(:answer)).to have_attributes(author: user)
      end

      it 'saves answer data' do
        expect(assigns(:answer)).to be_persisted
        expect(assigns(:answer)).to have_attributes(answer_data.slice(:text))
      end
    end

    context 'incorrect' do
      let(:answer_data) { attributes_for :answer, :invalid_text }
      let(:params) { { answer: answer_data } }
      it_behaves_like 'API Authorizable', :post, 422

      before { do_request :post, path }

      it 'returns error' do
        expect(json[:status]).to eq 'error'
        expect(json[:errors]).to_not be_empty
      end

      it 'not saves answer data' do
        expect(assigns(:answer)).to_not be_persisted
        expect(Answer.where(text: answer_data[:text])).to_not exist
      end
    end
  end

  describe 'PUT /api/v1/answers/#' do
    let(:path) { api_v1_answer_path(answer) }

    context 'other answer' do
      let(:answer) { create :answer }
      let(:answer_data) { attributes_for :answer, :updated }
      let(:params) { { answer: answer_data } }
      it_behaves_like 'API Authorizable', :put, 403

      before { do_request :put, path }

      it 'not saves answer data' do
        answer.reload
        expect(answer.text).to_not eq answer_data[:text]
      end
    end

    context 'own answer' do
      let(:answer) { create :answer, author: user }
      context 'correct' do
        let(:answer_data) { attributes_for :answer, :updated }
        let(:params) { { answer: answer_data } }
        it_behaves_like 'API Authorizable', :put

        before { do_request :put, path }

        it 'returns OK' do
          expect(json[:status]).to eq 'ok'
        end

        it 'saves answer data' do
          answer.reload
          expect(answer).to have_attributes(answer_data.slice(:text))
        end
      end

      context 'incorrect' do
        let(:answer_data) { attributes_for :answer, :invalid_text }
        let(:params) { { answer: answer_data } }
        it_behaves_like 'API Authorizable', :put, 422

        before { do_request :put, path }

        it 'returns error' do
          expect(json[:status]).to eq 'error'
          expect(json[:errors]).to_not be_empty
        end

        it 'not saves answer data' do
          answer.reload
          expect(answer.text).to_not eq answer_data[:text]
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/#' do
    let(:path) { api_v1_answer_path(answer) }

    context 'other answer' do
      let(:answer) { create :answer }
      it_behaves_like 'API Authorizable', :delete, 403

      before { do_request :delete, path }

      it 'not deletes answer' do
        expect(Answer.where(id: answer.id)).to_not be_empty
      end
    end

    context 'own answer' do
      let(:answer) { create :answer, author: user }
      it_behaves_like 'API Authorizable', :delete
    end
    context 'own answer' do
      let(:answer) { create :answer, author: user }

      before { do_request :delete, path }

      it 'returns OK' do
        expect(json[:status]).to eq 'ok'
      end

      it 'deletes answer' do
        expect(Answer.where(id: answer.id)).to be_empty
      end
    end
  end
end

