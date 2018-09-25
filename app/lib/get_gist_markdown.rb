class GetGistMarkdown
  def self.call(url)
    url += '/raw' unless url.end_with?('raw') || url.include?('raw')
    response = Faraday.get(url)
    response.body
  end
end
