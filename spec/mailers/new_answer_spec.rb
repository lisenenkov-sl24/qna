require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "new_answer" do
    let!(:user) { create :user }
    let!(:question) { create :question }
    let!(:qs) { create :question_subscription, user: user, question: question }
    let(:mail) { NewAnswerMailer.new_answer(qs) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body).to have_text(question.title)
    end
  end
end
