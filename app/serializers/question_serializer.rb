class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, user_id, :short_title
  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end
