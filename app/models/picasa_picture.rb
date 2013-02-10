class PicasaPicture
  attr_reader :uri

  def initialize doc
    @uri = doc.xpath("xmlns:content").attr("src").value
  end
end
