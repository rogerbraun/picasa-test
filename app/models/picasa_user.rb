class PicasaUser
  attr_reader :albums, :icon

  def initialize xml
    doc = Nokogiri::XML xml
    @icon = doc.search('icon').text
    @albums = doc.search("//atom:entry", "atom" => "http://www.w3.org/2005/Atom")
    @albums = @albums.map {|xml_entry|
      PicasaAlbum.new xml_entry
    }
  end

  def self.from_user user
    uri = "https://picasaweb.google.com/data/feed/api/user/default"
    response = GoogleOAuth.make_request uri, {access_token: user.access_token}, {format: 'xml'}
    self.new response
  end
end
