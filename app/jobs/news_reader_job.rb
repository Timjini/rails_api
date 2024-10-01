require 'net/http'
require 'uri'
require 'byebug'
require 'fileutils'
require 'open-uri'
require 'json'

class NewsReaderJob < ApplicationJob
  def perform
    send_request(website)
    html_content = HttpClient.global_get_request('https://www.bbc.com/')
    byebug
    timestamp = Time.now.strftime('%d-%m-%Y')
    safe_html, body_content, head_lines = extract_body_content(html_content)
    save_attachments_to_public(safe_html , "bbc#{timestamp}.html", 'public/html_files')
    save_attachments_to_public(body_content , "bbc_body_content#{timestamp}.txt", 'public/txt_files')
    save_attachments_to_public(head_lines.to_json , "bbc_head_lines#{timestamp}.json", 'public/json_files')
    # Output or process the HTML content as needed
    # puts html_content.force_encoding('UTF-8')
  end

  def send_request(url)
    byebug
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')  # Use SSL if it's an HTTPS URL
    
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    
    if response.is_a?(Net::HTTPSuccess)
      response.body  # Return the HTML content
    else
      raise "Failed to fetch the URL: #{response.message}"
    end
  end

  def save_attachments_to_public(attachment, filename, folder)
    return unless attachment

    # Save attachment to public directory
    attachments_dir = folder
    FileUtils.mkdir_p(attachments_dir)
    file_path = File.join(attachments_dir, filename)

    # Directly write binary data to file
    begin
      File.open(file_path, 'wb') do |file|
        file.write(attachment)
      end

      file_path
    rescue StandardError => e
      puts "Error saving attachment: #{e.message}"
      nil
    end
  end

  def extract_body_content(html)
    document = Nokogiri::HTML(html)
    body = document.at('body')

    # safe html 
    safe_html = document.css('script, style').remove
    # headlines only
    head_lines = {}
    body.css('h2').each_with_index do |header, index|
      head_lines[index] = header.text.strip
    end

    body_content = body.inner_html.strip 
    [safe_html, body_content, head_lines]
  end

end
