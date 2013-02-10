class PicasaAlbum

  attr_reader :title, :summary, :id, :numphotos, :thumbnail, :pictures

  def initialize xml
    if xml.class.to_s[/Nokogiri/]
      doc = xml
    else
      doc = Nokogiri::XML(xml).xpath("xmlns:feed")
    end
    @title = doc.xpath("xmlns:title").text
    @summary = doc.xpath("xmlns:summary").text || doc.xpath("xmlns:subtitle")
    @id = doc.xpath("gphoto:id").text
    @num_photos = doc.xpath("gphoto:numphotos").text
    @thumbnail = doc.xpath("media:group/media:thumbnail")
    @thumbnail = !@thumbnail.empty? ? @thumbnail.attr('url').value : doc.xpath('xmlns:icon')
    @pictures = doc.xpath("xmlns:entry")
    unless @pictures.empty?
      @pictures = @pictures.map do |xml_picture|
        PicasaPicture.new xml_picture
      end
    end
  end

  def self.from_id(album_id, user)
    uri = "https://picasaweb.google.com/data/feed/api/user/default/albumid/#{album_id}"
    response = GoogleOAuth.make_request uri, {access_token: user.access_token}, {format: 'xml'}
    self.new response
  end
end
