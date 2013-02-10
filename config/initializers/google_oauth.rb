require File.join(Rails.root,"lib","oauth_handler")

secrets = JSON.parse(File.read(File.join(Rails.root, "secrets", "client_secrets.json")))
auth_uri = secrets['web']['auth_uri']
token_uri = secrets['web']['token_uri']
scopes = ['https://picasaweb.google.com/data/', 'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email']
client_id =  secrets['web']['client_id']
client_secret = secrets['web']['client_secret']
redirect_uri = secrets['web']['redirect_uris'].first

GoogleOAuth = OAuthHandler.new(auth_uri, token_uri, client_id, client_secret, redirect_uri, scopes.join(" "))
