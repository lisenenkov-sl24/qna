require 'rails_helper'
require 'features/shared_comments'

feature 'User adds comment to an answer' do
  describe "nojs browser" do
    it_behaves_like :comments, 'answer', '.answers'
  end
  describe "js browser", js: true do
    it_behaves_like :comments, 'answer', '.answers'
    it_behaves_like :comments_channels, 'answer', '.answers'
  end
end
