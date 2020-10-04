module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_rateable, only: %i[rate_up rate_down cancel_vote]

    def rate_up
      authorize! :rate_up, @rateable
      @rateable.rate_up(current_user)

      success_response
    end

    def rate_down
      authorize! :rate_down, @rateable
      @rateable.rate_down(current_user)

      success_response
    end

    def cancel_vote
      authorize! :cancel_vote, @rateable
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
