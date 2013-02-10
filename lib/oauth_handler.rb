class OAuthHandler

  class TokenExpired < StandardError
  end

  def initialize(auth_uri, token_uri, client_id, client_secret, redirect_uri, scope)
    @auth_uri = auth_uri
    @token_uri = token_uri
    @client_id = client_id
    @client_secret = client_secret
    @redirect_uri = redirect_uri
    @scope = scope
  end

  # Gives the url that the controller should redirect to
  def authentication_url
    req_params = {
      response_type: 'code',
      client_id: @client_id,
      redirect_uri: @redirect_uri,
      scope: @scope,
    }
    @auth_uri + '?' + req_params.to_query
  end

  # Takes the data from the OAuth callback and gets a new token
  def get_token data
    req_params = {
      code: data["code"],
      client_id: @client_id,
      client_secret: @client_secret,
      redirect_uri: @redirect_uri,
      grant_type: 'authorization_code'
    }

    result = make_request @token_uri, req_params, {method: "post"}
    result[:access_token]
  end

  def make_request endpoint, data = {}, options = {}
    defaults = {method: 'get', format: 'json'}
    options = defaults.merge options

    data = {params: data} if options[:method] == 'get'
    begin
      response = RestClient.send options[:method], endpoint, data
    rescue => error
      if error.response["token expired"]
        raise TokenExpired
      else
        raise error
      end
    end
    response = JSON.parse response, symbolize_names: true if options[:format] == 'json'
    response
  end


end
