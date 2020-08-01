require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author) }
  it { should validate_presence_of :text }

  describe 'set best' do
    let(:question) { create :question_with_answers, answers_count: 5 }
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
      answer1.update(best: false )
      answer1.reload
      expect(answer1).to_not be_best
    end

  end

end
