class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy

  after_save :create_subscription

  include Rateable
  include Commentable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    answers.best_answer.first
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def create_subscription
    subscriptions.create(user_id: user_id, question_id: self)
  end
end
