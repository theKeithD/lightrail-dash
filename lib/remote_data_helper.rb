# Helper methods for retrieving data from remote sources.
module RemoteDataHelper
  # Fetch JSON from a remote source. Wrapper around remote().
  #
  # Handy for certain applications that serve JSON data but do not support JSONP callbacks.
  #--
  # (here's looking at you, Ganglia)
  def remote_json(url, limit = 10)
	remote("json", url, limit)
  end
  
  # Fetch XML from a remote source. Wrapper around remote().
  def remote_xml(url, limit = 10)
    remote("xml", url, limit)
  end
  
  # Fetch data from a remote source using the specified content type, following redirects if needed. Supports HTTP and HTTPS. Tested with +json+ and +xml+ for +content_type+.
  def remote(content_type, url, limit = 10)
    require 'net/http'
	require 'net/https'
	require 'uri'
	
	raise ArgumentError, "Max redirect limit reached" if limit == 0

    begin
      uri = URI.parse(url)
	  http = Net::HTTP.new(uri.host, uri.port)
	  if uri.scheme == "https"
	    http.use_ssl = true 
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	  end
	  
	  request = Net::HTTP::Get.new(uri.request_uri)
	  response = http.request(request)
	  
	  # follow redirects
	  case response
	    when Net::HTTPSuccess		then data = response.body
		when Net::HTTPRedirection	then data = remote(content_type, response.header['location'], limit - 1)
	  else
	    response.error!
	  end
    rescue
      data = { "response" => "error" }.send("to_#{content_type}")
    end

    data
  end
end