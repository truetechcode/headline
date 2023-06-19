require "httparty"

class NewsApi
  include HTTParty

  base_uri "https://newsapi.org" # Set the base URI for requests

  def initialize(country)
    @country = country || current_user.country
  end

  def call
    api_key = ENV.fetch("NEWSAPI_KEY", nil)
    response = self.class.get("/v2/top-headlines", query: { country: @country, apiKey: api_key })
    data = JSON.parse(response.body)

    raise StandardError, "#{response.code}: #{response.message}" if data["status"] == "error"

    live_articles = data["articles"].map do |article|
      {
        source: article["source"]["name"],
        author: article["author"],
        title: article["title"],
        description: article["description"],
        url: article["url"],
        url_to_image: article["urlToImage"],
        publish_at: article["publishedAt"],
        content: article["content"]
      }
    end
  rescue StandardError => e
    Rails.logger.error("NewsApi error: #{e.message}")
  end
end
