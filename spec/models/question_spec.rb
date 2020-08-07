require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(create(:question).files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'voting' do
    let!(:question) { create :question }
    let!(:vote) { create :vote, votable: question, rate: 1 }
    let(:user) { create :user }

    it 'rating' do
      expect(question.rating).to eq 1
    end

    it 'can\'t vote own' do
      expect { question.vote(question.author, 1) }.to_not change { question.rating }
    end

    it 'votes +' do
      expect { question.vote(user, 1) }.to change { question.rating }.by 1
    end

    it 'votes -' do
      expect { question.vote(user, -1) }.to change { question.rating }.by(-1)
    end

    it 'unvotes' do
      question.vote(user, 1)
      expect { question.unvote(user) }.to change { question.rating }.by(-1)
    end
    end

end
