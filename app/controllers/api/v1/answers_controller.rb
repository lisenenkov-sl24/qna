class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show update destroy]

  authorize_resource class: 'Answer'

  def index
    render json: @question.answers
  end

  def show
    render json: @answer, serializer: AnswerDetailSerializer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(author: current_resource_owner))
    if @answer.save
      render json: { status: :ok }
    else
      render json: { status: :error, errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: { status: :ok }
    else
      render json: { status: :error, errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: { status: :ok }
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