class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    answer.user = current_user
    answer.save
    respond_to do |format|
      format.js { flash.now[:notice] = 'Your answer posted successfully' }
    end
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    if current_user.is_author?(answer) && answer.destroy
      redirect_to question_path(answer.question), notice: 'Your answer deleted successfully'
    else
      redirect_to question_path(answer.question), alert: "You don't have permission to delete this answer"
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new(answer_params)
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answers
    @answers ||= question.answers
  end

  helper_method :answers

  def answer_params
    params.require(:answer).permit(:body)
  end
end
