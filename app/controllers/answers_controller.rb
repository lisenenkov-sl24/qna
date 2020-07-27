class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy]

  def create
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.author = current_user
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of? @answer
      @answer.destroy
      redirect_to @question, notice: 'Answer deleted.'
    else
      redirect_to @question, notice: 'Answer can\'t be deleted.'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text)
  end
end
