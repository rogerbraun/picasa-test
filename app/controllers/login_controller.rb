class LoginController < ApplicationController
  def sign_in
    redirect_to GoogleOAuth.authentication_url
  end

  def sign_out
    session[:user_id] = nil
    redirect_to root_path
  end

  def oauth2callback
    access_token = GoogleOAuth.get_token params
    user = User.find_or_create_from_token access_token

    session[:user_id] = user.id
    redirect_to session.delete(:return_path) || root_path
  end
end
