# frozen_string_literal: true

# Parses the article data from the API response body.
module ArticleParsing
  def self.parse(body)
    data = JSON.parse(body)
    data["articles"].map { |article| ArticleDataMapper.map(article) }
  end
end
