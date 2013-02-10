class User < ActiveRecord::Base
  attr_accessible :access_token, :email, :name, :oauth_id, :picture

  def self.find_or_signup(token_data, user_info)
    token_data.symbolize_keys!
    user_info.symbolize_keys!

    unless user = self.find_by_oauth_id(user_info[:id])
      user_info[:oauth_id] = user_info[:id]
      fields = user_info.merge(token_data).slice(:access_token, :email, :name, :oauth_id, :picture)
      user = User.create(fields)
    end
    user
  end
end
