class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[best edit update destroy deletefile]
  helper_method :new_answer

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

    unless current_user&.author_of? @question
      respond_to do |format|
        format.html { redirect_to @question, notice: 'Best answer can\'t be selected' }
        format.js { render status: 403, js: "alert('Best answer can\\\'t be selected')}')" }
      end
      return
    end

    @answer.update(best: true)

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
    return unless check_author 'Answer can\'t be deleted.'

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
    params.require(:answer).permit(:text, files: [])
  end

  def render_html_edit
    @edit_answer = @answer
    @question = @answer.question
    render 'questions/show'
  end

  def check_author(notice)
    result = current_user.author_of? @answer
    unless result
      respond_to do |format|
        format.html { redirect_to @answer.question, notice: notice }
        format.js { render status: 403, js: "alert('#{helpers.j(notice)}')" }
      end
    end
    result
  end

  def new_answer
    @new_answer ||= Answer.new
  end
end
