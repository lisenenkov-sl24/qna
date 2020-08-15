require 'rails_helper'

describe 'Profiles API', type: :request do
  include_context 'API token'

  describe 'GET /api/v1/profiles/me' do
    let(:path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable', :get

    before { do_request :get, path }

    it 'returns all public fields' do
      expect(json[:user]).to include jsonize(user, %i[id email created_at updated_at])
    end

    it 'does not return private fields' do
      expect(json[:user].slice(:admin, :password, :encrypted_password)).to be_empty
    end
  end

  describe 'GET /api/v1/profiles/notme' do
    let(:path) { '/api/v1/profiles/notme' }
    it_behaves_like 'API Authorizable', :get

    let!(:user2) { create :user }

    before { do_request :get, path }

    it 'returns all public fields' do
      expect(json[:users][0]).to include jsonize(user2, %i[id email created_at updated_at])
    end

    it 'does not return private fields' do
      expect(json[:users][0].slice(:admin, :password, :encrypted_password)).to be_empty
    end
  end
end
