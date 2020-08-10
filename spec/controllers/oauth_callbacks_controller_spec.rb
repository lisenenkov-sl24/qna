require 'rails_helper'
require 'controllers/shared/shared_oauth'

RSpec.describe OauthCallbacksController, type: :controller do
  describe 'Github' do
    it_behaves_like :oauth, :github
  end
  describe 'Facebook' do
    it_behaves_like :oauth, :facebook
  end
end
