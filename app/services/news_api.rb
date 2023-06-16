require 'httparty'

class NewsApi
  include HTTParty

  base_uri 'https://newsapi.org' # Set the base URI for requests

  def initialize(country)
    @country = country || current_user.country
  end

  def call
    begin
    api_key = ENV['NEWSAPI_KEY']
    response = self.class.get('/v2/top-headlines', query: { country: @country, apiKey: api_key })
    data = JSON.parse(response.body)

    if data['status'] == "error"
      raise StandardError.new "#{response.code}: #{response.message}"
    end

    live_articles = data['articles'].map do |article|
      {
        source: article['source']['name'],
        author: article['author'],
        title: article['title'],
        description: article['description'],
        url: article['url'],
        url_to_image: article['urlToImage'],
        publish_at: article['publishedAt'],
        content: article['content'],
      }
    end
  rescue => e
    Rails.logger.error("NewsApi error: #{e.message}")
  end
  end
end
