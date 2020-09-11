class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  
  def index; end

  def show
    answer.links.build
  end

  def new
    @question = Question.new
    question.links.build
    question.build_reward
  end

  def create
    question.user = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.is_author?(question)
  end

  def destroy
    if current_user.is_author?(question) && question.destroy
      redirect_to questions_path, notice: 'Your question deleted successfully'
    else
      redirect_to question_path(question), alert: "You don't have permissions to delete this question"
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new(question_params)
  end

  helper_method :question

  def questions
    @questions ||= Question.all
  end

  helper_method :questions

  def answers
    @answers ||= question.answers.sort_by_best
  end

  helper_method :answers

  def answer
    @answer ||= question.answers.build
  end

  helper_method :answer

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     reward_attributes: [:title, :image],
                                     links_attributes: [:name, :url, :done, :_destroy])
  end
end
