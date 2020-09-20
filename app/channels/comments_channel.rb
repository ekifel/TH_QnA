class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_for "comments_#{params[:question_id]}"
  end
end