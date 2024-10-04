class DocumentContentExtractor
  
  def self.extract_body_content(html)
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