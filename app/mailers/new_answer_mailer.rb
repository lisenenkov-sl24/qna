class NewAnswerMailer < ApplicationMailer
  def new_answer(question_subscription)
    @user = question_subscription.user
    @question = question_subscription.question
    mail to: @user.email
  end
end
