class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_#{params[:question]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
