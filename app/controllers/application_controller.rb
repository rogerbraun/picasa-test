class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from OAuthHandler::TokenExpired, with: :refresh_token

  def refresh_token
    session[:return_path] = request.path
    redirect_to login_sign_in_path
  end
end
