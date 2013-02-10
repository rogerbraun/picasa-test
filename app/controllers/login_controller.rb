class LoginController < ApplicationController
  def sign_in
    scopes = ['https://picasaweb.google.com/data/', 'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email']
    secrets = JSON.parse(File.read(File.join(Rails.root, "secrets", "client_secrets.json")))
    req_params = {
      response_type: 'code',
      client_id: secrets['web']['client_id'],
      redirect_uri: secrets['web']['redirect_uris'].first,
      scope: scopes.join(" ")
    }

    uri = secrets['web']['auth_uri'] + '?' + req_params.to_query
    redirect_to uri
  end

  def sign_out
    session[:user_id] = nil
  end

  def oauth2callback
    secrets = JSON.parse(File.read(File.join(Rails.root, "secrets", "client_secrets.json")))
    uri = "https://accounts.google.com/o/oauth2/token"
    req_params = {
      code: params["code"],
      client_id: secrets['web']['client_id'],
      client_secret: secrets['web']['client_secret'],
      redirect_uri: secrets['web']['redirect_uris'].first,
      grant_type: 'authorization_code'
    }
    token_data = JSON.parse(RestClient.post uri, req_params)

    user_info_uri = "https://www.googleapis.com/oauth2/v1/userinfo"

    user_info = JSON.parse(RestClient.get user_info_uri, {params: { access_token: token_data["access_token"]}})

    user = User.find_or_signup(token_data, user_info)
    session[:user_id] = user.id
    redirect_to root_path
  end
end
