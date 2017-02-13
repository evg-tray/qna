class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:create, :update, :destroy, :set_best_answer]
  before_action :set_answer, only: [:update, :destroy]

  after_action :publish_answer, only: [:create]

  respond_to :js

  def create
    @answer = @question.answers.create(answer_params)
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def set_best_answer
    @question.set_best_answer(Answer.find(params[:answer_id])) if current_user.author_of?(@question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy]).merge(user_id: current_user.id)
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast('answers', AnswersPresenter.new(@answer).as(:publish))
  end
end
