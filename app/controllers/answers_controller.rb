class AnswersController < ApplicationController
  before_action :authenticate_user!

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

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new(answer_params)
  end

  helper_method :answer

  def question
    @question ||= Question.with_attached_files.find(params[:question_id])
  end

  helper_method :question

  def answers
    @answers ||= question.answers
  end

  helper_method :answers

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
