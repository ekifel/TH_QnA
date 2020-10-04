class ApplicationController < ActionController::Base
  before_action :set_gon_current_user

  check_authorization unless: :devise_controller?

  private

  def set_gon_current_user
    gon.user_id = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        redirect_to root_path, alert: exception.message
      end
      format.json do
        render json: { error: exception.message }, status: 403
      end
      format.js do
        render json: { error: exception.message }, status: 403
      end
    end
  end
end
