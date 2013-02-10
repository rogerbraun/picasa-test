class HomeController < ApplicationController
  def index
    @user = User.find(session[:user_id]) if session[:user_id]
    @picasa_user = @user.picasa_user if @user
  end
end
