module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :rates, as: :rateable, dependent: :destroy
  end

  def rate_up(user)
    return if user.is_author?(self)

    rate = rates.find_or_initialize_by(user: user)

    rate.update!(status: 1)
  end

  def rate_down(user)
    return if user.is_author?(self)

    rate = rates.find_or_initialize_by(user: user)

    rate.update!(status: -1)
  end

  def cancel_vote(user)
    rates.find_by(user: user)&.destroy
  end

  def rating
    rates.sum(:status)
  end
end
