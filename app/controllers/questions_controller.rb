class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy deletefile]
  after_action :publish_question, only: [:create]

  include Voted

  authorize_resource

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

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions', {
        action: params[:action],
        data: ApplicationController.render(partial: 'questions/channel_question', locals: { question: @question })
    }
  end
end
