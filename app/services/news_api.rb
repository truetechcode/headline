# frozen_string_literal: true

require "httparty"

# Represents a News API client for retrieving top headlines based on a country.
class NewsApi
  include HTTParty

  base_uri "https://newsapi.org" # Set the base URI for requests

  # Initializes a new instance of the NewsApi class.
  #
  # @param country [String] The country for which to retrieve top headlines.
  def initialize(country)
    @country = country || current_user.country
  end

  # Calls the News API to retrieve top headlines for the specified country.
  #
  # @return [Array<Hash>] An array of article data.
  # @raise [StandardError] If the API response indicates an error.
  def call
    api_key = ENV.fetch("NEWSAPI_KEY", nil)
    response = self.class.get("/v2/top-headlines", query: { country: @country, apiKey: api_key })
    data = JSON.parse(response.body)

    raise StandardError, "#{response.code}: #{response.message}" if data["status"] == "error"

    data_mapper data["articles"]
  end
rescue StandardError => e
  Rails.logger.error("NewsApi error: #{e.message}")
end

  private

def data_mapper(data)
  data.map { |article| map_article_data(article) }
end

def map_article_data(article)
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
