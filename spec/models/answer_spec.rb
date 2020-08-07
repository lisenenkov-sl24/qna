require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :text }

  describe 'set best' do
    let(:question) { create :question_with_answers, answers_count: 5 }
    let!(:reward) { create :reward, question: question }
    let(:answer1) { question.answers[1] }
    let(:answer2) { question.answers[2] }

    before { answer1.update(best: true) }

    it 'set with no best' do
      answer1.reload
      answer2.reload
      expect(answer1).to be_best
      expect(answer2).to_not be_best
    end

    it 'change best answer' do
      answer2.update(best: true)
      answer1.reload
      answer2.reload
      expect(answer1).to_not be_best
      expect(answer2).to be_best
    end

    it 'unset best answer' do
      answer1.update(best: false)
      answer1.reload
      expect(answer1).to_not be_best
    end

    it 'rewards user' do
      reward.reload
      expect(reward).to have_attributes user: answer1.author
    end
  end

  it 'have many attached files' do
    expect(create(:answer).files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'voting' do
    let!(:answer) { create :answer }
    let!(:vote) { create :vote, votable: answer, rate: 1 }
    let(:user) { create :user }

    it 'rating' do
      expect(answer.rating).to eq 1
    end

    it 'can\'t vote own' do
      expect { answer.vote(answer.author, 1) }.to_not change { answer.rating }
    end

    it 'votes +' do
      expect { answer.vote(user, 1) }.to change { answer.rating }.by 1
    end

    it 'votes -' do
      expect { answer.vote(user, -1) }.to change { answer.rating }.by(-1)
    end

    it 'unvotes' do
      answer.vote(user, 1)
      expect { answer.unvote(user) }.to change { answer.rating }.by(-1)
    end
  end

end
