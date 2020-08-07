require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should allow_values(-1, 1).for(:rate) }
  it { should_not allow_values(0, 2).for(:rate) }

  describe 'uniqueness of user votable pair' do
    # it { should validate_uniqueness_of(:user).scoped_to(:votable) }
    # not worked

    let!(:vote) { create :vote }

    it 'invalld' do
      new_vote = build :vote, user: vote.user, votable: vote.votable
      expect(new_vote).to_not be_valid
    end

    it 'valld' do
      new_vote = build :vote, user: vote.user
      expect(new_vote).to be_valid
      new_vote = build :vote, votable: vote.votable
      expect(new_vote).to be_valid
    end
  end
end
