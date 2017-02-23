class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]

  authorize_resource

  def index
    @answers = @question.answers
    respond_with(@answers, each_serializer: AnswersSerializer)
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with(@answer)
  end

  def create
    @answer = @question.answers.create(answer_params)
    respond_with(:api, :v1, @answer)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user_id: current_resource_owner.id)
  end
end