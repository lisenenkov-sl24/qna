class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :find_question, only: %i[show edit update destroy]

  helper_method :new_answer

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :create }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    question_saved = @question.update(question_params)
    respond_to do |format|
      format.html do
        if question_saved
          redirect_to @question, notice: 'Your question successfully saved.'
        else
          render :edit
        end
      end
      format.js do
        render question_saved ? :update : :edit
      end
    end
  end

  def destroy
    return unless check_author 'Question can\'t be deleted.'

    @question.destroy
    redirect_to questions_path, notice: 'Question deleted.'
  end


  def best
    @question = Question.find(params[:question_id])
    return unless check_author 'Best answer can\'t be selected.'

    @question.update(best_answer_id: params[:id])
    respond_to do |format|
      format.html { redirect_to @question, notice: 'Best question changed' }
      format.js
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

  def check_author(notice)
    result = current_user.author_of? @question
    redirect_to @question, notice: notice unless result
    result
  end

  def new_answer
    @new_answer ||= Answer.new
  end
end
