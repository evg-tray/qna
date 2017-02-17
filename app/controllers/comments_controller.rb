class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]

  authorize_resource

  respond_to :json

  def create
    return render_error unless Comment.types.include?(params[:comment][:commentable_type])
    @comment = commentable.comments.build(comment_params)
    if @comment.save
      render json: CommentsPresenter.new(@comment).as(:create)
    else
      render_error
    end
  end

  private

  def render_error
    render json: { error_text: 'Error to comment.' }, status: :unprocessable_entity
  end

  def commentable
    @commentable ||= params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def publish_comment
    return if @comment.nil? || @comment.errors.any?
    ActionCable.server.broadcast('comments', CommentsPresenter.new(@comment).as(:publish))
  end
end