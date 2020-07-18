class QuestionsController < ApplicationController
  before_action :find_question, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :resque_with_question_not_found

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def resque_with_question_not_found
    render status: 404, plain: 'question not found'
  end

end
