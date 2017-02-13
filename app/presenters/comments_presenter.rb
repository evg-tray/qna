class CommentsPresenter

  def initialize(comment)
    @comment = comment
  end

  def as(presence)
    send("present_as_#{presence}")
  end

  private

  def present_as_create
    {
        body: @comment.body,
        css_path: selector
    }
  end

  def present_as_publish
    {
        css_path: selector,
        body: @comment.body,
        author_comment: @comment.user.id
    }
  end

  def selector
    @comment.commentable.is_a?(Question) ? '.question' : ".answer-#{@comment.commentable.id}"
  end
end