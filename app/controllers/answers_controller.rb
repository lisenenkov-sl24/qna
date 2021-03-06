class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[best edit update destroy deletefile]
  after_action :publish_answer, only: [:create]

  include Voted

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @new_answer = Answer.new(answer_params.merge(question: @question, author: current_user))
    answer_saved = @new_answer.save
    respond_to do |format|
      format.html do
        if answer_saved
          redirect_to @question, notice: 'Your answer successfully created.'
        else
          render 'questions/show'
        end
      end
      format.js
    end
  end

  def best
    @question = @answer.question

    @answer.update(best: true)

    respond_to do |format|
      format.html { redirect_to @question, notice: 'Best answer changed' }
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html { render_html_edit }
      format.js
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer.question }
        format.js { render :update }
      else
        format.html { render_html_edit }
        format.js { render :edit }
      end
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to @question, notice: 'Answer deleted.' }
      format.js
    end

  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def render_html_edit
    @edit_answer = @answer
    @question = @answer.question
    render 'questions/show'
  end

  def publish_answer
    return if @new_answer.errors.any?

    render_data = helpers.content_tag :tr, class: 'answer', data: { id: @new_answer.id } do
      ApplicationController.render(partial: 'answers/channel_data',
                                   locals: { answer: @new_answer, question: @question })
    end

    ActionCable.server.broadcast "answers_#{@question.id}", {
        action: params[:action],
        id: @new_answer.id,
        data: render_data
    }
  end
end
