class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question_owner_id, only: :show

  after_action :publish_question, only: :create

  include Rated
  include Commented

  authorize_resource

  def index; end

  def show
    answer.links.build
    gon.question_id = question.id
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
    question.update(question_params)
  end

  def destroy
    question.destroy
    flash[:notice] = 'Your question deleted successfully'
    redirect_to root_path
  end

  private

  def publish_question
    return if question.errors.any?

    QuestionsChannel.broadcast_to('questions', question)
  end

  def set_question_owner_id
    gon.question_owner_id = question.user.id
  end

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
