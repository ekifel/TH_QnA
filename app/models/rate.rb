class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :status, presence: true
end
