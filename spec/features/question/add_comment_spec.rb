require 'rails_helper'
require 'features/shared_comments'

feature 'User adds comment to a question' do
  describe "nojs browser" do
    it_behaves_like :comments, 'question', '.question'
  end
  describe "js browser", js: true do
    it_behaves_like :comments, 'question', '.question'
    it_behaves_like :comments_channels, 'question', '.question'
  end
end
