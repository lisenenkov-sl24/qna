class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[best edit update destroy]
  helper_method :new_answer

  def create
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
    @question = @edit_answer.question

    unless current_user&.author_of? @question
      respond_to do |format|
        format.html { redirect_to @question, notice: 'Best answer can\'t be selected' }
        format.js { render status: 403, js: "alert('Best answer can\\\'t be selected')}')" }
      end
      return
    end

    @edit_answer.update(best: true)

    @edit_answer = nil
    respond_to do |format|
      format.html { redirect_to @question, notice: 'Best question changed' }
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
    return unless check_author 'Answer can\'t be updated.'

    answer_saved = @edit_answer.update(answer_params)
    respond_to do |format|
      format.html do
        if answer_saved
          redirect_to @edit_answer.question
        else
          render_html_edit
        end
      end
      format.js do
        @question = @edit_answer.question
        @answer = @edit_answer
        @edit_answer = nil if answer_saved
      end
    end
  end

  def destroy
    return unless check_author 'Answer can\'t be deleted.'

    @question = @edit_answer.question
    @edit_answer.destroy
    respond_to do |format|
      format.html { redirect_to @question, notice: 'Answer deleted.' }
      format.js
    end

  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @edit_answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text)
  end

  def render_html_edit
    @question = @edit_answer.question
    render 'questions/show'
  end

  def check_author(notice)
    result = current_user.author_of? @edit_answer
    unless result
      respond_to do |format|
        format.html { redirect_to @edit_answer.question, notice: notice }
        format.js { render status: 403, js: "alert('#{helpers.j(notice)}')" }
      end
    end
    result
  end

  def new_answer
    @new_answer ||= Answer.new
  end
end
