require 'rails_helper'

RSpec.describe Ability, type: :controller do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create :user }

    let(:user_question) { create :question, :with_files, author: user }
    let(:user_answer) { create :answer, :with_files, author: user }
    let(:user_question_answer) { create :answer, question: user_question }

    let(:other_question) { create :question, :with_files }
    let(:other_answer) { create :answer, :with_files }
    let(:other_question_answer) { create :answer, question: user_question }


    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to %i[create destroy], Subscription }

    it { should be_able_to %i[edit update destroy], user_question }
    it { should_not be_able_to %i[vote unvote], user_question }
    it { should_not be_able_to %i[edit update destroy], other_question }
    it { should be_able_to %i[vote unvote], other_question }

    it { should be_able_to %i[edit update destroy], user_answer }
    it { should_not be_able_to %i[vote unvote], user_answer }
    it { should_not be_able_to %i[edit update destroy], other_answer }
    it { should be_able_to %i[vote unvote], other_answer }

    it { should be_able_to %i[destroy], user_question.files[0] }
    it { should_not be_able_to %i[destroy], other_question.files[0] }
    it { should be_able_to %i[destroy], user_answer.files[0] }
    it { should_not be_able_to %i[destroy], other_answer.files[0] }

    it { should be_able_to %i[best], create(:answer, question: user_question) }
    it { should_not be_able_to %i[best], create(:answer, question: other_question) }
  end
end
