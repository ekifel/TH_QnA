class ApplicationController < ActionController::Base
  before_action :get_gon_current_user

  private

  def get_gon_current_user
    gon.current_user = current_user
  end
end
