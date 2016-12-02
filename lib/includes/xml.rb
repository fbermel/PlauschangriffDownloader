class Xml
  
  def initialize
    begin
      @doc = Nokogiri::XML(open("http://rocketbeans.tv/plauschangriff.xml"))
    rescue StandardError => e
      raise StandardError.new(e)
    end
  end
  
  def getPodcastNames
    @podcastnames = Array.new
    @doc.xpath('//item').each do |parent|
      @podcastnames.push(parent.xpath('./title').text)
    end
    @podcastnames
  end
  
  def escape_single_quotes_for_xpath(string)
    if string =~ /'/
      %[concat('] + string.gsub(/'/, %[', "'", ']) + %[')] # horribly, this is how you escape single quotes in XPath.
    else
      %['#{string}']
    end
end
   
  def getDownloadLink(podcastname)
    pod = escape_single_quotes_for_xpath(podcastname.to_s)
    expression = "//title[text() = #{pod}]/.."
    node = @doc.xpath(expression)
    node.xpath('./enclosure/@url').to_s
  
  end
  
end
