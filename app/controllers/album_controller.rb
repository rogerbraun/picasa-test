class AlbumController < ApplicationController
  def show
    redirect_to root_path unless session[:user_id]
    @user = User.find(session[:user_id])
    @album = @user.picasa_album params[:id]
    @pictures = @album.pictures.take(3)
    @pictures.each{|picture| picture.load_comments @user }
  end

  def comment_picture
    @user = User.find(session[:user_id])
    uri = "https://picasaweb.google.com/data/feed/api/user/default/albumid/#{params[:id]}/photoid/#{params[:picture_id]}"
    data = """
    <entry xmlns='http://www.w3.org/2005/Atom'>
      <content>#{params[:content]}</content>
      <category scheme='http://schemas.google.com/g/2005#kind'
        term='http://schemas.google.com/photos/2007#comment'/>
      </entry>
    """
    begin
    GoogleOAuth.make_request uri, {access_token: @user.access_token, body: data}, {format: 'none', method: 'post'}
    rescue => e
      binding.pry
    end
    redirect_to :back
  end
end
