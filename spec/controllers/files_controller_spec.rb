require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create :user }


  describe 'DELETE #destroy' do

    describe 'authorized user' do
      before { login user }

      describe 'question' do
        let(:question) { create :question, :with_files, author: user }

        it 'deletes file from own question' do
          login user
          delete :destroy, params: { id: question.files[0] }
          question.reload
          expect(question.files.count).to eq 0
        end

        it 'keep file from other user question' do
          login create(:user)
          delete :destroy, params: { id: question.files[0] }
          question.reload
          expect(question.files.count).to eq 1
        end
      end

      describe 'answer' do
        let(:answer) { create :answer, :with_files, author: user }

        it 'deletes file from own answer' do
          login user
          delete :destroy, params: { id: answer.files[0] }
          answer.reload
          expect(answer.files.count).to eq 0
        end

        it 'keep file from other user answer' do
          login create(:user)
          delete :destroy, params: { id: answer.files[0] }
          answer.reload
          expect(answer.files.count).to eq 1
        end
      end
    end

    describe 'unauthorized user' do
      it 'keep file from question' do
        question = create :question, :with_files, author: user
        delete :destroy, params: { id: question.files[0] }
        question.reload
        expect(question.files.count).to eq 1
      end
    end
  end

end
