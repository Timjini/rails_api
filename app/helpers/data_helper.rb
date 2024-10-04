module DataHelper
  
  def news_content(options)
    timestamp = Time.now.strftime('%d-%m-%Y')
    content_array = [
        {
        content: options[:safe_html],
        title: "bbc#{timestamp}.html",
        folder: "public/html_files"
        },
        {
          content: options[:body_content],
          title: "bbc_body_content#{timestamp}.txt",
          folder: "public/txt_files"
        },
        {
          content: options[:head_lines].to_json,
          title: "bbc_head_lines#{timestamp}.json",
          folder: "public/json_files"
        }
      ]
  end
end