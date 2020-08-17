class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_answer, -> { where(best: true) }
  scope :sort_by_best, -> { order(best: :desc) }

  def select_best
    transaction do
      question.best_answer&.update!(best: false)
      update!(best: true)
    end
  end
end
