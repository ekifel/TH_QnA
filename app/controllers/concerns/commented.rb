module Commented
  extend ActiveSupport::Concern

  included do
    helper_method :record
    helper_method :comment

    after_action :broadcast_comment, only: :create_comment
  end

  def create_comment
    authorize! :create_comment, record
    comment.user = current_user
    comment.save
  end

  private

  def broadcast_comment
    return if comment.errors.any?

    CommentsChannel.broadcast_to("comments_#{question.id}", comment)
  end

  def record
    send(controller_name.singularize.underscore)
  end

  def comment
    @comment ||= record.comments.build(comment_params)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
