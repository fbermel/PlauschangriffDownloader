class Prepare
    
  def initialize()
             
  end
  
  def sanitize(filename)
    bad_chars = [ '/', '\\', '?', '%', '*', ':', '|', '"', '<', '>' ]
    bad_chars.each do |bad_char|
      filename.gsub!(bad_char, ' ')
    end
    filename
  end
  
  def getSize(url)
    res = nil
    urlbase = url.split('/')[2]
    urlpath = '/'+url.split('/')[3..-1].join('/')
    Net::HTTP.start(urlbase, 80) do |http|
      res = http.head(urlpath)
    end
    res['content-length'].to_f
  end
end
