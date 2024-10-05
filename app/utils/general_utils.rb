class GeneralUtils

  def self.add_root_to_url(url)
    root = 'https://www.bbc.com'
    if !url.include?(root)
        url.prepend(root)
    end
    url
  end
end