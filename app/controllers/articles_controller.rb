# frozen_string_literal: true

# This is a ArticlesController responsible for managing article-related actions.
class ArticlesController < ApplicationController
  before_action :signed_in_user

  def index
    articles = current_user.articles
    country_code = fetch_country_code
    news_service = NewsApi.new(country_code)
    live_articles = news_service.call || []

    respond_to do |format|
      format.html do
        render locals: { articles:, live_articles:, country_code: }
      end
      format.json { render json: { saved_headlines: articles, headlines: live_articles }, status: :ok }
    end
  end

  def create
    article = build_article
    if article.save
      handle_successful("saved", :created, article)
    else
      handle_failed article.errors.full_messages.join
    end
  end

  def destroy
    article = Article.find_by(id: params[:id])

    if article&.destroy
      handle_successful("deleted", nil, article)
    elsif article.nil?
      handle_not_found "Headline not found"
    else
      handle_failed article.errors.full_messages.join
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

  def handle_successful(item, status, article)
    Rails.logger.info("Headline successfully #{item}")

    respond_to do |format|
      format.html do
        flash[:success] = "Headline successfully #{item}"
        redirect_to root_path
      end
      format.json { render json: { message: "Headline successfully #{item}", headline: article }, status: }
    end
  end

  def handle_failed(error_message)
    Rails.logger.error error_message

    respond_to do |format|
      format.html do
        flash.now[:error] = error_message
        render "new"
      end

      format.json { render json: { error: error_message }, status: :unprocessable_entity }
    end
  end

  def handle_not_found(message)
    Rails.logger.error message
    respond_to do |format|
      format.html do
        flash[:error] = message
        redirect_to articles_url
      end
      format.json { render json: { error: message }, status: :unprocessable_entity }
    end
  end

  protected

  def articles_params
    params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at,
                                    :user)
  end
end
