class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_#{params[:question]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
