# frozen_string_literal: true

# Generates article data map
class ArticleDataMapper
  def self.map(article)
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
end
