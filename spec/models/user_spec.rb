require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:restrict_with_error) }
  it { should have_many(:answers).dependent(:restrict_with_error) }

  describe 'test author' do
    let(:user) { create :user }
    let(:user2) { create :user }

    context 'answer' do
      it 'own' do
        answer = create :answer, author: user
        expect(user.author_of?(answer)).to be_truthy
      end
      it 'not own' do
        answer = create :answer, author: user2
        expect(user.author_of?(answer)).to be_falsey
      end
    end
    context 'questions' do
      it 'own' do
        question = create :question, author: user
        expect(user.author_of?(question)).to be_truthy
      end
      it 'not own' do
        question = create :question, author: user2
        expect(user.author_of?(question)).to be_falsey
      end
    end

  end
end
