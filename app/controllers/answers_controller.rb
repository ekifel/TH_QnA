class AnswersController < ApplicationController
  def show; end

  def new; end

  def edit; end

  def create
    if answer.save
      redirect_to question_path(question)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_path(question)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy

    redirect_to question_path(question)
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new(answer_params)
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question
end
