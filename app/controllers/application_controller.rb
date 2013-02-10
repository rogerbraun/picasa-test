class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from OAuthHandler::TokenExpired, with: :refresh_token

  # Get a new token and redirect back to wherever we where before.
  def refresh_token
    session[:return_path] = request.path
    redirect_to login_sign_in_path
  end
end
