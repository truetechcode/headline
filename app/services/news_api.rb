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
    @country = country
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

    data["articles"].map { |article| ArticleDataMapper.map(article) }
  end
rescue StandardError => e
  Rails.logger.error("NewsApi error: #{e.message}")
end
