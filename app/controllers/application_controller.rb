class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include Pagy::Backend
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  helper_method :current_user_safe
  def current_user_safe
    current_user || User.new
  end
  

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :phone, :user_image ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :phone, :user_image ])
  end
end
