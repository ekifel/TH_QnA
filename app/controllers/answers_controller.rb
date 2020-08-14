class AnswersController < ApplicationController
  before_action :authenticate_user!

  def edit; end

  def create
    answer.user = current_user
    if answer.save
      redirect_to question_path(question), notice: 'Your answer posted successfully'
    else
      render 'questions/show', locals: { model: [question, answer] }
    end
  end

  def update
    if current_user.is_author?(answer) && answer.update(answer_params)
      redirect_to question_path(question), notice: 'Answer updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if current_user.is_author?(answer) && answer.destroy
      redirect_to question_path(question), notice: 'Answer deleted successfully'
    else
      redirect_to question_path(question), alert: "You don't have permission to delete this answer"
    end
  end

  private

  def answer
    @answer ||= params[:id] ? answers.find(params[:id]) : question.answers.new(answer_params)
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
