class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_parent
  after_action :publish_comment

  def create
    @comment = Comment.new(comment_params.merge(commentable: @commentable, user: current_user))
    comment_saved = @comment.save
    respond_to do |format|
      format.html do
        if comment_saved
          redirect_to @question, notice: 'Your comment successfully created.'
        else
          render 'questions/show'
        end
      end
      format.js
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def find_parent
    if params[:question_id]
      @question = Question.find(params[:question_id])
      @commentable = @question
    else
      @commentable = Answer.find(params[:answer_id])
      @question = @commentable.question
    end
  end

  def publish_comment
    return if @comment.errors.any?
    render_data = ApplicationController.render(partial: 'comments/comment', locals: { comment: @comment })
    ActionCable.server.broadcast "comments_#{@question.id}", ApplicationController.render(json: {
        action: params[:action],
        parent: { type: @commentable.class.to_s, id: @commentable.id },
        id: @comment.id,
        data: render_data
    })
  end
end
