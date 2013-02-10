class PicasaPicture
  attr_reader :uri, :comments, :id, :album_id

  def initialize doc
    @uri = doc.xpath("xmlns:content").attr("src").value
    @id = doc.xpath("gphoto:id").text
    @album_id = doc.xpath("gphoto:albumid").text
    @comment_count = doc.xpath("gphoto:commentCount").text.to_i
    @comments = []
  end

  # Only load these on demand
  def load_comments user
    if @comment_count > 0
      req_uri = "https://picasaweb.google.com/data/feed/api/user/default/albumid/#{@album_id}/photoid/#{@id}"
      results = GoogleOAuth.make_request req_uri, {kind: "comment", access_token: user.access_token}, {format: "xml"}
      doc = Nokogiri::XML results
      entries = doc.xpath("xmlns:feed/xmlns:entry")
      @comments = entries.map do |entry|
        {
          author: entry.xpath("xmlns:title").text,
          content: entry.xpath("xmlns:content").text
        }
      end
    end
  end
end
