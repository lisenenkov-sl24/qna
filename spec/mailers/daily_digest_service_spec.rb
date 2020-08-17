require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create :user }
    let!(:question) { create :question }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body).to have_link(question.title)
    end
  end
end
