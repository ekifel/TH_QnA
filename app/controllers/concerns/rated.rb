module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_rateable, only: %i[rate_up rate_down cancel_vote]

    def rate_up
      @rateable.rate_up(current_user)

      success_response
    end

    def rate_down
      @rateable.rate_down(current_user)

      success_response
    end

    def cancel_vote
      @rateable.cancel_vote(current_user)

      success_response
    end

    private

    def set_rateable
      @rateable = model_klass.find(params[:id])
    end

    def model_klass
      controller_name.classify.constantize
    end

    def success_response
      render json: { id: @rateable.id, type: @rateable.class.name.downcase, rating: @rateable.rating }
    end
  end
end
