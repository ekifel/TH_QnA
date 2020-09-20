class AnswersController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_answer, only: :create

  include Rated
  include Commented

  def create
    answer.user = current_user
    if answer.save
      respond_to do |format|
        format.js { flash.now[:notice] = 'Your answer posted successfully!' }
      end
    end
  end

  def update
    answer.update(answer_params) if current_user.is_author?(answer)
  end

  def destroy
    if current_user.is_author?(answer) && answer.destroy
      respond_to do |format|
        format.js { flash.now[:notice] = 'Your answer deleted successfully!' }
      end
    else
      redirect_to question_path(question)
    end
  end

  def choose_as_best
    answer.select_best if current_user.is_author?(answer.question)
  end

  private

  def publish_answer
    return if answer.errors.any?

    AnswersChannel.broadcast_to(
        "answers_#{question.id}",
        {
            answer: answer,
            template: render_to_string(partial: 'answers/answer', locals: { resource: answer, current_user: nil })
        }
    )
  end

  def answer
    @answer ||= Answer.with_attached_files.find_by(id: params[:id]) || question.answers.new(answer_params)
  end

  helper_method :answer

  def question
    @question ||= Question.with_attached_files.find_by(id: params[:question_id]) || answer.question
  end

  helper_method :question

  def answers
    @answers ||= question.answers
  end

  helper_method :answers

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :done, :_destroy])
  end
end
