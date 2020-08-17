class NewAnswerService
  def new_answer(answer)
    answer.question.question_subscriptions.find_each(batch_size: 500) do |qs|
      NewAnswerMailer.new_answer(qs).deliver_later
    end
  end
end
