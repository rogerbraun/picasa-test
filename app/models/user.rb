class User < ActiveRecord::Base
  attr_accessible :access_token, :email, :name, :oauth_id, :picture

  def self.find_or_create_from_token(access_token)
    user_info = GoogleOAuth.make_request("https://www.googleapis.com/oauth2/v1/userinfo", access_token: access_token)

    fields = user_info.slice(:email, :name, :oauth_id, :picture)
    fields[:access_token] = access_token

    unless user = self.find_by_oauth_id(user_info[:id])
      user_info[:oauth_id] = user_info[:id]
      user = User.create(fields)
    else
      user.update_attribute(:access_token, fields[:access_token])
    end

    user
  end

  def picasa_album album_id
    PicasaAlbum.from_id album_id, self
  end

  def picasa_user
    picasa_user = PicasaUser.from_user self
  end
end
