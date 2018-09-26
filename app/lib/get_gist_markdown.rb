class GetGistMarkdown
  URL_REGEX = /(?<new_url>.*[\/][0-z]*)/
  def self.call(url)
    url = url.match(URL_REGEX)[:new_url]
    unless url.end_with?('raw') || url.include?('raw')
      url =
        url.sub('github', 'githubusercontent') +
        '/raw'
    end
    response = Faraday.get(url)
    response.body
  end
end
