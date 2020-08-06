class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy deletefile]

  helper_method :new_answer

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new(reward: Reward.new)
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
    return unless check_author(@question, 'Question can\'t be deleted.')

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
    return unless check_author(questions_path, 'Question can\'t be deleted.')

    @question.destroy
    redirect_to questions_path, notice: 'Question deleted.'
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:name, :file])
  end

  def check_author(path, notice)
    result = current_user&.author_of? @question
    unless result
      respond_to do |format|
        format.html { redirect_to path, notice: notice }
        format.js { render status: 403, js: "alert('#{helpers.j(notice)}')" }
      end
    end
    result
  end

  def new_answer
    @new_answer ||= Answer.new
  end
end
