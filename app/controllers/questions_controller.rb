class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy, :set_best_answer]
  before_action :build_answer, only: :show
  after_action :publish_question, only: [:create]

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def show
    gon.question_id = @question.id
    respond_with(@question)
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with(@question)
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    respond_with(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', @question)
  end
end
