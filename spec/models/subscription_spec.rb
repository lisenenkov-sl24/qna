require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  subject { create :subscription }
  describe 'uniqueness of user votable pair' do
    # it { should validate_uniqueness_of(:user).scoped_to(:question) }
    # not worked

    let!(:qs) { create :subscription }

    it 'invalld' do
      new_qs = build :subscription, user: qs.user, question: qs.question
      expect(new_qs).to_not be_valid
    end

    it 'valld' do
      new_qs = build :subscription, user: qs.user
      expect(new_qs).to be_valid
      new_qs = build :subscription, question: qs.question
      expect(new_qs).to be_valid
    end
  end
end

