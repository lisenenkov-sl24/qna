class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_subscription, only: [:destroy]

  authorize_resource

  def create
    @question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
