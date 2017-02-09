class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]

  def create
    return render_error unless Comment.types.include?(params[:comment][:commentable_type])
    @comment = commentable.comments.build(comment_params)
    if @comment.save
      render json: {
          body: @comment.body,
          css_path: selector
      }
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
    ActionCable.server.broadcast(
      'comments',
      css_path: selector,
      body: @comment.body,
      author_comment: @comment.user.id
    )
  end

  def selector
    @selector ||= @comment.commentable.is_a?(Question) ? '.question' : ".answer-#{@comment.commentable.id}"
  end
end