class QuestionsController < ApplicationController
  before_action :find_question, only: %i[show edit update destroy createanswer deleteanswer]
  before_action :authenticate_user!, only: %i[new create createanswer deleteanswer]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def createanswer
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render :show
    end
  end

  def deleteanswer
    @answer = @question.answers.find(params[:answer_id])
    if @answer.author == current_user
      @answer.destroy
      redirect_to @question, notice: 'Answer deleted.'
    else
      redirect_to @question, notice: 'Answer can\'t be deleted.'
    end
  end

  def destroy
    if @question.author == current_user
      @question.destroy
      redirect_to questions_path, notice: 'Question deleted.'
    else
      redirect_to questions_path, notice: 'Question can\'t be deleted.'
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def answer_params
    params.require(:answer).permit(:text)
  end
end
