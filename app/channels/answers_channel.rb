class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_for "answers_#{params[:question_id]}"
  end
end
