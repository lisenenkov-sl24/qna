class QuestionSubscriptionController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  authorize_resource

  def create
    @question.question_subscriptions.create(user: current_user)
  end

  def destroy
    question_subscription = @question.question_subscriptions.find_by(user: current_user)
    question_subscription.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
