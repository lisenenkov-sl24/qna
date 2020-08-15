shared_examples 'Model Votable' do
  describe 'voting' do
    let!(:vote) { create :vote, votable: votable, rate: 1 }
    let(:user) { create :user }

    it 'rating' do
      expect(votable.rating).to eq 1
    end

    it 'can\'t vote own' do
      expect { votable.vote(votable.author, 1) }.to_not change { votable.rating }
    end

    it 'votes +' do
      expect { votable.vote(user, 1) }.to change { votable.rating }.by 1
    end

    it 'votes -' do
      expect { votable.vote(user, -1) }.to change { votable.rating }.by(-1)
    end

    it 'unvotes' do
      votable.vote(user, 1)
      expect { votable.unvote(user) }.to change { votable.rating }.by(-1)
    end
  end

end

