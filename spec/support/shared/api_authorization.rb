shared_examples 'API Authorizable' do |method, status_code = 200|
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request method, path, { params: with_params({}) }
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request method, path, { params: with_params({ access_token: '1234' }) }
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    include_context 'API token'
    before { do_request method, path }

    it "returns #{status_code} status" do
      expect(response.status).to eq status_code
    end
  end
end

shared_context 'API token' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:access_token_params) { { access_token: access_token.token } }
end