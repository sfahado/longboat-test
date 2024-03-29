# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?

  def current_user
    @current_user = @user || User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.blank?
  end

  def authenticate_user!
    redirect_to new_login_path unless logged_in?
  end
end
