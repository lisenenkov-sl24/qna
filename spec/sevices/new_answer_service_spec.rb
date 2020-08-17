require 'rails_helper'

RSpec.describe NewAnswerService do
  let!(:question) { create :question }
  let!(:answer) { create :answer, question: question }
  let!(:question_subscriptions) { create_list :question_subscription, 10, question: question }

  it 'sends info about new answer to all subscribed users' do
    question.question_subscriptions.each { |qs| expect(NewAnswerMailer).to receive(:new_answer).with(qs).and_call_original }
    subject.new_answer(answer)
  end
end