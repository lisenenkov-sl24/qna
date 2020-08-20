require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #index' do

    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    let(:post_data) { { area: 'all', text: 'text' } }

    it 'renders index view' do
      allow_any_instance_of(SearchService).to receive(:search)
      post :create, params: post_data
      expect(response).to render_template :create
    end

    it 'calls SearchService.search view' do
      expect_any_instance_of(SearchService).to receive(:search).with(:all, 'text')
      post :create, params: post_data
    end
  end
end
