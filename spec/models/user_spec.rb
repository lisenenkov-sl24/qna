require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:restrict_with_error) }
  it { should have_many(:answers).dependent(:restrict_with_error) }
  it { should have_many(:rewards).dependent(:nullify) }

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
end
