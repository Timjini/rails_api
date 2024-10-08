class DocumentContentExtractor
  
  def self.extract_body_content(html)
    document = Nokogiri::HTML(html)
    body = document.at('body')
    content = document.at('main')
    # content = document.css('.content-container')
    # safe html 
    safe_html = content.to_html
    head_lines = {}
    content.css('a').each_with_index do |header, index|
      current_line = {}
      current_line['url'] = header['href']
      h2 = header.at('h2')
      current_line['headline'] = h2.text.strip if h2
      p = header.at('p')
      current_line['description'] = p.text.strip if p
      img = header.at('img')
      current_line['image_url'] = img['src'] if img
      head_lines[index] = current_line
    end

    body_content = body.inner_html.strip 
    [safe_html, body_content, head_lines]
  end
end