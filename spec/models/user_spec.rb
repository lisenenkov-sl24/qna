require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:restrict_with_error) }
  it { should have_many(:answers).dependent(:restrict_with_error) }
  it { should have_many(:rewards).dependent(:nullify) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe '.get_vote' do
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

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }
    let(:find_for_oauth) { User.find_for_oauth!(auth) }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
        expect(find_for_oauth).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        it 'does not create new user' do
          expect { find_for_oauth }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { find_for_oauth }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = find_for_oauth.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(find_for_oauth).to eq user
        end
      end

      context 'user does not exist' do
        let!(:user) { build :user }

        it 'creates new user' do
          expect { find_for_oauth }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(find_for_oauth).to be_a(User)
        end

        it 'fills user email' do
          expect(find_for_oauth.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          expect(find_for_oauth.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = find_for_oauth.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
