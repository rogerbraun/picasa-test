class AlbumController < ApplicationController
  def show
    redirect_to root_path unless session[:user_id]
    @user = User.find(session[:user_id])
    @album = @user.picasa_album params[:id]
    @pictures = @album.pictures.take(3)
  end
end
