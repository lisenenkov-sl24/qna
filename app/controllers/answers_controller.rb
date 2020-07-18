class AnswersController < ApplicationController
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :resque_with_answer_not_found

  def index
    @answers = @question.answers
  end

  def show; end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_answers_path(@answer.question)
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

  def resque_with_answer_not_found
    render status: 404, plain: 'answer not found'
  end
end
