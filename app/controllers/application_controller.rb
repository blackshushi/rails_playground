class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :current_user_name, :guest_user?
  before_action :authenticate_user!

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def guest_user?
    session[:guest_name].present?
  end

  def current_user_name
    if current_user
      return current_user.name
    end

    return "#{session[:guest_name]}(Guest)"
  end

  def authenticate_user!
    unless current_user || guest_user?
      flash[:alert] = "Please login to access this page"
      redirect_to login_path
    end
  end
end
