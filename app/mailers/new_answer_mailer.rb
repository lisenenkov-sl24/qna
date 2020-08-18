class NewAnswerMailer < ApplicationMailer
  def new_answer(subscription)
    @user = subscription.user
    @question = subscription.question
    mail to: @user.email
  end
end
