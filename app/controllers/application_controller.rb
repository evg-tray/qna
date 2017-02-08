class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
