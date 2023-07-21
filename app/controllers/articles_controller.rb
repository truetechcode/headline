# frozen_string_literal: true

# This is a ArticlesController responsible for managing article-related actions.
class ArticlesController < ApplicationController
  before_action :signed_in_user

  def index
    articles = current_user.articles
    country_code = fetch_country_code
    news_service = NewsApi.new(country_code)
    live_articles = news_service.call || []

    render locals: { articles:, live_articles:, country_code: }
  end

  def create
    article = build_article
    return unless article.save

    handle_successful("saved")
  end

  def destroy
    article = Article.find_by(id: params[:id])

    if article&.destroy
      handle_successful("deleted")
    elsif article.nil?
      handle_not_found "Headline not found"
    end
  end

  private

  def fetch_country_code
    (params[:country] || current_user.country_code).downcase
  end

  def build_article
    current_user.articles.build(articles_params).tap do |article|
      article.user = current_user
    end
  end

  def handle_successful(item)
    Rails.logger.info("Headline successfully #{item}")

    flash[:success] = "Headline successfully #{item}"
    redirect_to root_path
  end

  def handle_not_found(message)
    Rails.logger.error message
    flash[:error] = message
    redirect_to articles_url
  end

  protected

  def articles_params
    params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at,
                                    :user)
  end
end
