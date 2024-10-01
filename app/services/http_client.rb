require 'net/http'
require 'uri'

class HttpClient 
  
  def self.global_get_request(url, options = {})
    website = URI.parse(url)
    http = Net::HTTP.new(website.host, website.port)
    http.use_ssl = (website.scheme == 'https')
    
    request = Net::HTTP::Get.new(website.request_uri)
    response = http.request(request)
    
    if response.is_a?(Net::HTTPSuccess)
      response.body
    else
      raise "Failed to fetch the URL: #{response.message}"
    end
  end
end