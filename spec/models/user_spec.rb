require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:restrict_with_error) }
  it { should have_many(:answers).dependent(:restrict_with_error) }
  it { should have_many(:rewards).dependent(:nullify) }
  it { should have_many(:votes).dependent(:destroy) }

  describe 'test author' do
    let(:user) { create :user }

    it 'own' do
      question = create :question, author: user
      expect(user).to be_author_of(question)
    end
    it 'not own' do
      question = create :question, author: create(:user)
      expect(user).to_not be_author_of(question)
    end

  end

  describe 'get_vote' do
    let(:user) { create :user }
    let(:question) { create :question }

    it 'if voted' do
      vote = create :vote, user: user, rate: 1, votable: question
      expect(user.get_vote(question)).to eq 1
    end

    it 'if not voted' do
      expect(user.get_vote(question)).to be_nil
    end
  end
end
