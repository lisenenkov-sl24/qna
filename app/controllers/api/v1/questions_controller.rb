class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]

  authorize_resource class: 'Question'

  def index
    render json: Question.all
  end

  def show
    render json: @question, serializer: QuestionDetailSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: { status: :ok }
    else
      render json: { status: :error, errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: { status: :ok }
    else
      render json: { status: :error, errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render json: { status: :ok }
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end