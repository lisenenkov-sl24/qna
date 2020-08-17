require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:question_subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_users).through(:question_subscriptions) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(create(:question).files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'Model Votable' do
    let!(:votable) { create :question }
  end

  it 'subscribed after created question' do
    question = create :question
    expect(question.subscribed_users.where(id: question.author)).to exist
  end

end
