class AnswersController < ApplicationController
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[show edit update destroy]
  before_action :authenticate_user!, only:  %i[new create edit update destroy]

  def index
    @answers = @question.answers
  end

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to @answer
    else
      render :new
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
