require 'net/http'
require 'uri'
require 'byebug'
require 'fileutils'
require 'open-uri'
require 'json'

class NewsReaderJob < ApplicationJob
  include DataHelper
  def perform(websites= nil)
    # 'https://www.bbc.com/'
    website = 'https://www.msn.com/en-us'
    html_content = HttpClient.global_get_request(website)
    safe_html, body_content, head_lines = DocumentContentExtractor.extract_body_content(html_content)

    options = {safe_html: safe_html, body_content: body_content, head_lines: head_lines}
    content_array = news_content(options)
    content_array.each do |content|
      AttachmentsHandler.save_attachments_to_public(content[:content] , content[:title], content[:folder])
    end
    # Output or process the HTML content as needed
    # puts html_content.force_encoding('UTF-8')
  end

end
